import kcls.models.github_workflow as gw
import kcls.common.github as ghc
import kcls.common.docker

schema DockerDeploySwarmOpts:
    image_name: str
    service_name: str
    task_name: str = "app"
    environment: "staging" | "production"
    extra_env_trigger: str = ""

DockerDeploySwarm = lambda opt: DockerDeploySwarmOpts {
    _workflow_name = "Deploy docker ${opt.environment}"
    _job: gw.Job = {
        name = _workflow_name
        steps = [
            ghc.CheckoutRepo
            ghc.GetVersionFromTag
            ghc.DockerLogin
            ghc.InstallDarklabSshKey
            docker.Build(docker.BuildOpts {
                image_name = opt.image_name
                if opt.environment == "staging":
                    tag = opt.environment
                else:
                    tag = ghc.GetVersionOutput
                    extra_tags = [opt.environment]
                push = True
            })
            docker.DeploySwarm(docker.DeploySwarmOpts {
                image_name = opt.image_name
                tag = opt.environment
                service_name = "${opt.environment}-${opt.service_name}-${opt.task_name}"
            })
            if opt.extra_env_trigger != "":
                docker.DeploySwarm(docker.DeploySwarmOpts {
                    image_name = opt.image_name
                    tag = opt.environment
                    service_name = "${opt.extra_env_trigger}-${opt.service_name}-${opt.task_name}"
                })
        ]
    }
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
        env = ghc.DockerHostEnv
        jobs = {
            job = _job
        }
    }
    # return
    _workflow
}
