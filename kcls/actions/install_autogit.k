
import yaml
import ..models.github_action as gh

_name = "Install Autogit"
_filename = "install-autogit"

_action = gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                shell: "bash"
                run=  r"go install github.com/darklab8/autogit/v2@latest"
            },
        ]
    }
}

schema InstallAutogit(gh.Step):
    name: str = _name
    uses: str = r"darklab8/infra/.github/actions/install-autogit@master"
