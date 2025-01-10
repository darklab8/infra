import .github_action as gh

schema TriggerPush:
    branches?: [str]
    tags?: [str]
    "tags-ignore"?: [str]

schema Triggers:
    push?: TriggerPush
    schedule?: [ScheduleCron]
    workflow_dispatch?: {str: str} 
    workflow_call?: {str:str}

schema ScheduleCron:
    cron: str

schema Permissions:
    pages?: "write"
    "id-token"?: "write"

schema Job:
    name: str
    "runs-on"?: str = "ubuntu-22.04"
    permissions?: Permissions
    environment?: {str: str}
    steps?: [gh.Step]
    needs?: [str]

schema JobDispatch(Job):
    name: str
    uses: str
    secrets = "inherit"
    steps?: [gh.Step] = None
    "runs-on"?: str = None

schema Workflow:
    _filename?: str
    name: str
    on: Triggers
    jobs: {str: Job}
    env?: {str: str}


