import kcls.models.github_action as ga

schema BuildOpts(ga.StepOpts):
    "site-host": str
    "site-root": str
    "freelancer-folder": str
    "heading": str
    "relay-host": str
    "apigateway-host": str
    is_detailed?: bool

schema BuildArgs:
    site_host: str
    site_root: str
    freelancer_folder: str
    heading: str
    relay_host: str = ""
    apigateway_host: str = ""

schema Build[opt: BuildArgs](ga.Step):
    name: str = "Darkstat Build"
    uses: str = r"darklab8/fl-darkstat/.github/actions/build@master"
    with: BuildOpts = BuildOpts {
        "site-host" = opt.site_host
        "site-root" = opt.site_root
        "freelancer-folder" = opt.freelancer_folder
        heading = opt.heading
        "relay-host" = opt.relay_host
        "apigateway-host" = opt.apigateway_host
    }

