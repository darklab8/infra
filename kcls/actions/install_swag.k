
import kcls.models.github_action as gh

_name = "Install Swag"

_action = gh.GHAction{
    name = _name
    runs = {
        steps = [
            gh.Step{
                name: _name
                shell: "bash"
                run: 'go install github.com/swaggo/swag/cmd/swag@v1.16.4'
            },
        ]
    }
}
_filename = "install-swag"

schema SwagInstall(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"

schema SwagBuild(gh.Step):
    name: str = "Build swag go stuff"
    run: str = "swag init --parseDependency"
