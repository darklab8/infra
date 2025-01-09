
import yaml
import kcls.github_action as gh

_name = "Install Go"

yaml.dump_to_file(
    gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                uses: "actions/setup-go@v5"
                with = {
                    "go-version": '^1.22.5'
                }
            },
        ]
    }
}, 
    ".github/actions/${_filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
_filename = "install-go"

schema InstallGo(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
