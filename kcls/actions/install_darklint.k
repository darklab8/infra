
import yaml
import kcls.models.github_action as gh

_name = "Install Darklint"

_action = gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                shell: "bash"
                run=  r"go install github.com/darklab8/fl-darklint@latest"
            },
        ]
    }
}

_filename = "install-darklint"

schema InstallDarklint(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
