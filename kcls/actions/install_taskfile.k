
import kcls.models.github_action as gh

_name = "Install Taskfile"

_action = gh.GHAction{
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
}

_filename = "install-taskfile"

schema InstallTaskfile(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
