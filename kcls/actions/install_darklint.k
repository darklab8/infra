
import yaml
import kcls.github_action as gh

_name = "Install Darklint"

yaml.dump_to_file(
    gh.GHAction{
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
}, 
    ".github/actions/${_filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
_filename = "install-darklint"

schema InstallDarklint(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
