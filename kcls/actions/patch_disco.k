
import yaml
import kcls.github_action as gh

_name = "Patch freelancer discovery to latest"

yaml.dump_to_file(
    gh.GHAction{
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
}, 
    ".github/actions/${_filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
_filename = "patch-disco"

schema PatchDiscoOpts(gh.StepOpts):
    "freelancer-folder": str

schema PatchDisco(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
    with: PatchDiscoOpts
