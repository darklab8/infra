
import yaml
import kcls.github_action as gh

_name = "Install Autogit"

yaml.dump_to_file(
    gh.GHAction{
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
}, 
    ".github/actions/install-autogit/action.yml",
    ignore_private=True,
    ignore_none=True,
)

schema InstallAutogit(gh.Step):
    name: str = _name
    uses: str = r"darklab8/infra/.github/actions/install-autogit@master"
