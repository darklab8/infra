import kcls.models.github_action as ga
import kcls.models.github_workflow as gw
import template

CheckoutRepo = ga.Step {
    name = "Check out source repository"
    uses = "actions/checkout@v4"
}
CheckoutRepoWithCommits = ga.Step {
    name = "Check out source repository with commits history"
    uses = "actions/checkout@v4"
    with: {"fetch-depth": 0}
}

schema PagesDeployOpts:
    path: str = "./build"

PagesToDeploySteps = lambda a: PagesDeployOpts {
    [
        ga.Step {
            name = "Upload artifacts for deployment to Github Pages"
            uses = "actions/upload-pages-artifact@v3"
            with: {
                name = "github-pages"
                path = a.path
            }
        }
        ga.Step {
            name = "Deploy to pages"
            uses = "actions/deploy-pages@v4"
            id = "deployment"
        }
    ]
}

schema PagesPermissions(gw.Permissions):
    pages: str = "write"
    "id-token": str = "write"
    contents = "read"

schema PagesEnvironment:
    name = "github-pages"
    url: str = r"${{ steps.deployment.outputs.page_url }}"

schema UploadBinariesStepOpts:
    body: str = ""
    files: [str]

schema UploadBinariesStep[opts: UploadBinariesStepOpts](ga.Step):
    name = "upload binaries to release"
    uses = "softprops/action-gh-release@v2"
    $if = r"${{startsWith(github.ref, 'refs/tags/') }}"
    with = {
        if opts.body != "":
            body = opts.body
        files = template.execute("""{{# each files}}
{{this}}
{{/each}}
""", {files = opts.files})
    }

schema TriggerWorkflowDispatchOpts:
    repository: str

schema TriggerWorkflowDispatch[opts: TriggerWorkflowDispatchOpts](ga.Step):
    uses = "peter-evans/repository-dispatch@v3"
    with = {
        token = r"${{ secrets.FL_DATA_KEY }}"
        repository: opts.repository
        "event-type": "publish"
    }

InstallDarklabSshKey = ga.Step {
    name = "Install Darklab ssh key"
    run = r"""mkdir ~/.ssh | true
echo "${{ secrets.SSH_KEY_BASE64 }}" | base64 --decode > ~/.ssh/id_rsa
echo "Host darkbot" > ~/.ssh/config
echo "    HostName 37.27.207.42" >> ~/.ssh/config
echo "    User root" >> ~/.ssh/config
echo "    IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
echo "    IdentitiesOnly yes" >> ~/.ssh/config
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
ssh-keyscan -H 37.27.207.42 >> ~/.ssh/known_hosts | true
ssh-keyscan -H darkbot >> ~/.ssh/known_hosts | true
"""
}

GetVersionFromTag = ga.Step {
    name = "Get version from tag"
    id = "version"
    run = r"""set -x
echo "BUILD_VERSION=${GITHUB_REF#refs/*/}" >> $GITHUB_OUTPUT
"""
}
GetVersionOutput = r"${{ steps.version.outputs.BUILD_VERSION }}"

TagsSemverProduction = ["*", "!*-*"]
TagsSemverStaging = ["*-*"]
