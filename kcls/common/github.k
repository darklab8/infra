import kcls.models.github_action as ga

CheckoutRepo = ga.Step{
    name = "Check out source repository"
    uses = "actions/checkout@v2"
}