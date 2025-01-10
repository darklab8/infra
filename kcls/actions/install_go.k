
import kcls.models.github_action as gh

_name = "Install Go"

_action = gh.GHAction{
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
}
_filename = "install-go"

schema InstallGo(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
