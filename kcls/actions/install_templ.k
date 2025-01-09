
import yaml
import kcls.github_action as gh

_name = "Install Templ"

yaml.dump_to_file(
    gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                shell: "bash"
                run: 'go install github.com/a-h/templ/cmd/templ@v0.2.747'
            },
        ]
    }
}, 
    ".github/actions/${_filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
_filename = "install-templ"

schema InstallTempl(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
