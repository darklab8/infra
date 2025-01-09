
import yaml
import kcls.github_action as gh

_name = "Install Taskfile"

yaml.dump_to_file(
    gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                shell: "bash"
                run: 'sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin'
            },
        ]
    }
}, 
    ".github/actions/${_filename}/action.yml",
    ignore_private=True,
    ignore_none=True,
)
_filename = "install-taskfile"

schema InstallTaskfile(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
