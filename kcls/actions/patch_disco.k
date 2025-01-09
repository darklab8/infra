
import yaml
import kcls.models.github_action as gh

_name = "Patch freelancer discovery to latest"

_action = gh.GHAction{
    name = _name
    inputs = {
        "freelancer-folder": {
            description = "Path to Discovery Freelancer u wish to patch"
        }
    }
    runs = {
        steps = [
            gh.Step{
                name: "Install Discovery patcher"
                shell: "bash"
                run: 'go install github.com/darklab8/fl-data-discovery@latest'
            },
            gh.Step{
                name: "Patch to latest"
                shell: "bash"
                run: r'fl-data-discovery -wd ${{ inputs.freelancer-folder }}'
            },
        ]
    }
}


_filename = "patch-disco"

schema PatchDiscoOpts(gh.StepOpts):
    "freelancer-folder": str

schema PatchDisco(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
    with: PatchDiscoOpts
