
import kcls.models.github_action as gh

_name = "Install Swag"

_action = gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                uses: "github.com/swaggo/swag/cmd/swag@v1.16.4"
            },
        ]
    }
}
_filename = "install-swag"

schema InstallSwag(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"
