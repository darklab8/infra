schema GHAction:
    name: str
    description: str = ""
    inputs?: {str: Input}
    runs: Runs

schema Input:
    description: str
    default?: str
    required?: bool

schema Runs:
    using: "composite"
    steps: [Step]

schema Step:
    name?: str
    $if?: str
    shell?: "python" | "bash"
    run?: str
    env?: {str: str}
    uses?: str
    with?: StepOpts | {str : str|int}
    id?: str
    "continue-on-error"?: bool

schema StepWithOutput:
    Step: Step
    Output: str

schema StepOpts:
    "optional to step"
