import kcls.models.github_action as ga
import kcls.actions.install_autogit as autogit
import template

DOCKER_HOST_ARM64 = "ssh://root@darkbot"
DOCKER_HOST_AMD64 = "unix:///var/run/docker.sock"
DockerHostEnv = {
    DOCKER_HOST = DOCKER_HOST_ARM64
}

schema DockerLogin(ga.Step):
    name = "Docker login"
    run = r'echo "${{ secrets.DOCKERHUB_TOKEN }}" | docker login --username darkwind8 --password-stdin'

schema BuildOpts:
    image_name: str
    context: str = "."
    tag: str
    extra_tags?: [str]
    push: bool = False

schema BuildMultiArchOpts(BuildOpts):
    docker_host_arm64: str = DOCKER_HOST_ARM64
    docker_host_amd64: str = DOCKER_HOST_AMD64
    push: bool = True

schema Build[opt: BuildOpts](ga.Step):
    name = "Build image ${opt.image_name}"
    run = template.execute("""set -ex
export tag_version={{tag}}
docker build --build-arg "BUILD_VERSION=$tag_version" --tag ${opt.image_name}:$tag_version {{context}}

{{# each extra_tags}}
docker tag ${opt.image_name}:$tag_version ${opt.image_name}:{{this}}
{{/each}}

{{#if push}}
docker push ${opt.image_name}:$tag_version
sleep 5
{{# each extra_tags}}
docker push ${opt.image_name}:{{this}}
sleep 5
{{/each}}
{{/if}}
""", {
        tag = opt.tag
        image_name = opt.image_name
        context = opt.context
        extra_tags= opt.extra_tags
        push = opt.push
    })

schema BuildMultiArch[opt: BuildMultiArchOpts](ga.Step):
    name = "Build image ${opt.image_name}"
    run = template.execute("""set -ex
export tag_version={{tag}}
DOCKER_HOST=${opt.docker_host_arm64} docker build --build-arg "BUILD_VERSION=$tag_version" --tag ${opt.image_name}:\${tag_version}-arm64 {{context}}
DOCKER_HOST=${opt.docker_host_amd64} docker build --build-arg "BUILD_VERSION=$tag_version" --tag ${opt.image_name}:\${tag_version}-amd64 {{context}}
DOCKER_HOST=${opt.docker_host_arm64} docker push ${opt.image_name}:\${tag_version}-arm64
sleep 5
DOCKER_HOST=${opt.docker_host_amd64} docker push ${opt.image_name}:\${tag_version}-amd64
sleep 5
docker manifest create ${opt.image_name}:\${tag_version} --amend ${opt.image_name}:\${tag_version}-arm64 --amend ${opt.image_name}:\${tag_version}-amd64
docker manifest push ${opt.image_name}:\${tag_version}
{{# each extra_tags}}
docker manifest create ${opt.image_name}:\${tag_version} --amend ${opt.image_name}:\${tag_version}-arm64 --amend ${opt.image_name}:\${tag_version}-amd64
docker manifest push ${opt.image_name}:{{this}}
{{/each}}
""", {
        tag = opt.tag
        image_name = opt.image_name
        context = opt.context
        extra_tags= opt.extra_tags
        push = opt.push
    })

schema PullOpts:
    image_name: str
    tag: str

schema Pull[opt: PullOpts]:
    name = "Pull ${opt.image_name}:${opt.tag}"
    run = """set -ex
docker pull ${opt.image_name}:${opt.tag}
sleep 5
"""

schema RetagOpts:
    image_name: str
    old_tag: str
    new_tag: str
    pull: bool = False
    push: bool = False

schema Retag[opt: RetagOpts](ga.Step):
    name = "Retag from ${opt.old_tag} to ${opt.new_tag}"
    run = template.execute("""set -ex
{{#if pull}}
docker pull {{image_name}}:{{old_tag}}
sleep 5
{{/if}}
docker tag {{image_name}}:{{old_tag}} {{image_name}}:{{new_tag}}
{{#if push}}
docker push {{image_name}}:{{new_tag}}
sleep 5
{{/if}}
""", { 
        pull = opt.pull 
        push = opt.push 
        old_tag = opt.old_tag
        new_tag = opt.new_tag
        image_name = opt.image_name
    })

schema DeploySwarmOpts:
    image_name: str
    service_name: str
    tag: "staging" | "production"
    pull: bool = True

schema DeploySwarm[opt: DeploySwarmOpts](ga.Step):
    name = "Switch service image ${opt.image_name} for swarm to new one"
    run = template.execute("""set -ex
{{#if pull}}
docker pull {{image_name}}:{{tag}}
sleep 5
{{/if}}
docker service update --image {{image_name}}:{{tag}} {{service_name}}
"""{ 
        pull = opt.pull 
        tag = opt.tag
        service_name = opt.service_name
        image_name = opt.image_name
    })
