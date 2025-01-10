import kcls.models.github_action as ga
import kcls.actions.install_autogit as autogit
import template

schema BuildOpts:
    image_name: str
    context: str = "."

schema Build[opts: BuildOpts](ga.Step):
    name = "Build image ${opts.image_name}"
    run = """docker build --build-arg "BUILD_VERSION=${autogit.GetVersionOutput}" --tag ${opts.image_name}:${autogit.GetVersionOutput} ${opts.context}"""

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
docker pull ${opt.image_name}:${opt.old_tag}
sleep 5
{{/if}}
docker tag ${opt.image_name}:${opt.old_tag} ${opt.image_name}:${opt.new_tag}
{{#if push}}
docker push ${opt.image_name}:${opt.new_tag}
sleep 5
{{/if}}
""", { 
        pull = opt.pull 
        push = opt.push 
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
docker pull ${opt.image_name}:${opt.tag}
sleep 5
{{/if}}
docker service update --image ${opt.image_name}:${opt.tag} ${opt.service_name}
"""{ 
        pull = opt.pull 
    })
