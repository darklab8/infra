
import ..models.github_action as gh

_name = "Install Autogit"
_filename = "install-autogit"

_action = gh.GHAction{
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
}

schema InstallAutogit(gh.Step):
    name: str = _name
    uses: str = r"darklab8/infra/.github/actions/install-autogit@master"

GetChangelogStep = Step = gh.Step{
    name = "Print release changelog"
    id = "changelog"
    run = """echo 'artifact<<EOF' >> $GITHUB_OUTPUT
autogit changelog >> "$GITHUB_OUTPUT"
echo 'EOF' >> $GITHUB_OUTPUT
"""
}
GetChangelogOutput = r"${{ steps.changelog.outputs.artifact }}"


GetVersionStep = gh.Step {
    name: "get autogit semantic version"
    id: "version"
    run: r"""set -x
echo "BUILD_VERSION=$(autogit semver --alpha --build ${{ github.run_number }} | sed 's/\+/-build/')" >> $GITHUB_OUTPUT
"""   
}
GetVersionOutput = r"${{ steps.version.outputs.BUILD_VERSION }}"

