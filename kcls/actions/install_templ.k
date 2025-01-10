
import kcls.models.github_action as gh

_name = "Install Templ"

_action = gh.GHAction{
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
}

_filename = "install-templ"

schema InstallTempl(gh.Step):
    name: str = _name
    uses: str = "darklab8/infra/.github/actions/${_filename}@master"

schema GenerateTempl(gh.Step):
    name: str = "generate Templ files"
    run: str = "templ generate"
