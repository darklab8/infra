import .github_action as gh

schema TriggerPush:
    branches?: [str]

schema Triggers:
    push?: TriggerPush
    schedule: [ScheduleCron]

schema ScheduleCron:
    cron: str

schema Permissions:
    pages?: "write"
    "id-token"?: "write"

schema Job:
    name: str
    "runs-on": str = "ubuntu-22.04"
    permissions?: Permissions
    environment?: {str: str}
    steps: [gh.Step]

schema Workflow:
    name: str
    on: Triggers
    jobs: {str: Job}


