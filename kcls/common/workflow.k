import kcls.models.github_workflow as gw
import kcls.common.github as ghc
import kcls.common.docker

schema DockerDeploySwarmOpts:
    image_name: str
    service_name: str
    task_name: str = "app"
    environment: "staging" | "production"
    extra_services: [str] = []

DockerDeploySwarm = lambda opt: DockerDeploySwarmOpts {
    _workflow_name = "Deploy docker ${opt.environment}"
    _workflow = gw.Workflow {
        _filename = "docker-${opt.environment}.yml"
        name = _workflow_name
        on = {
            if opt.environment == "staging":
                push.tags: ghc.TagsSemverStaging
            else:
                push.tags: ghc.TagsSemverProduction
            workflow_dispatch: {}
        }
        jobs = {
            "build-arm64" = gw.Job {
                name = "Build arm64"
                env = docker.DockerHostArm64Env
                steps = [
                    ghc.CheckoutRepo
                    ghc.GetVersionFromTag
                    docker.DockerLogin {}
                    ghc.InstallDarklabSshKey
                    docker.Build(docker.BuildOpts {
                        arch_suffix = "arm64"
                        push = True
                        image_name = opt.image_name
                        if opt.environment == "staging":
                            tag = opt.environment
                        else:
                            tag = ghc.GetVersionOutput
                            extra_tags = [opt.environment]
                    })
                ]
            }
            "build-amd64" = gw.Job {
                name = "Build amd64"
                env = docker.DockerHostAmd64Env
                steps = [
                    ghc.CheckoutRepo
                    ghc.GetVersionFromTag
                    docker.DockerLogin {}
                    ghc.InstallDarklabSshKey
                    docker.Build(docker.BuildOpts {
                        arch_suffix = "amd64"
                        push = True
                        image_name = opt.image_name
                        if opt.environment == "staging":
                            tag = opt.environment
                        else:
                            tag = ghc.GetVersionOutput
                            extra_tags = [opt.environment]
                    })
                ]
            }
            deploy = gw.Job {
                env = docker.DockerHostArm64Env
                name = "Join And Deploy"
                needs = ["build-arm64", "build-amd64"]
                steps = [
                    ghc.GetVersionFromTag
                    docker.DockerLogin {}
                    ghc.InstallDarklabSshKey
                    # became broken with docker manifest create error, amd64 is already manifest list
                    # docker.JoinMultiArch(docker.BuildOpts {
                    #     image_name = opt.image_name
                    #     if opt.environment == "staging":
                    #         tag = opt.environment
                    #     else:
                    #         tag = ghc.GetVersionOutput
                    #         extra_tags = [opt.environment]
                    # })
                    docker.DeploySwarm(docker.DeploySwarmOpts {
                        image_name = opt.image_name
                        tag = "${ghc.GetVersionOutput}-arm64"
                        service_name = "${opt.environment}-${opt.service_name}-${opt.task_name}"
                    })
                ] + [docker.DeploySwarm(docker.DeploySwarmOpts {
                    image_name = opt.image_name
                    tag = "${ghc.GetVersionOutput}-arm64"
                    service_name = service
                }) for service in opt.extra_services]
            }
        }
    }
    # return
    _workflow
}
