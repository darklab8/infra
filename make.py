#!/usr/bin/env python3
import argparse
from enum import Enum, auto
import subprocess
import inspect
from scripts.config import Config

subprocess.run("./prepare_secrets.sh", shell=True, check=True)

config = Config()

darklab_hcloud_token = config["darklab_ci_hcloud_token"]

darklab_infra_project_id = config["darklab_gitlab_infra_repo_id"]
darklab_gitlab_apikey = config["darklab_gitlab_apikey"]
darklab_gitlab_user = config["darklab_gitlab_user"]

darklab_cloudflare_token = config["darklab_cloudflare_token"]

class Actions(Enum):
    git_remote = auto()
    hetzner = auto()
    terraform_init = auto()
    cloudflare_check = auto()
    deploy = auto()
    prepare_secrets = auto()


parser = argparse.ArgumentParser()

actions = parser.add_subparsers(dest="action", required=True)

actions.add_parser(Actions.git_remote.name)

hetzner = actions.add_parser(Actions.hetzner.name)
hetzner.add_argument("object", choices=["datacenters", "images"])

terraform_init = actions.add_parser(Actions.terraform_init.name)
terraform_init.add_argument("environment", choices=["ci"])

cloudflare_check = actions.add_parser(Actions.cloudflare_check.name)

deploy = actions.add_parser(Actions.deploy.name)
deploy.add_argument("environment", choices=["ci"])

args = parser.parse_args()

match Actions[args.action]:
    case Actions.git_remote:
        subprocess.run(inspect.cleandoc("""
        git remote remove origin || true
         && git remote add origin git@github.com-dd84ai:darklab8/darklab_infrastructure.git
         && git remote set-url --add --push origin git@github.com-dd84ai:darklab8/darklab_infrastructure.git
         && git remote set-url --add --push origin git@gitlab.com-dd84ai:darklab2/darklab_infrastructure.git
        """).replace("\n",""), shell=True, check=True)
    case Actions.hetzner:
        
        subprocess.run((
            'curl -H'
            f' "Authorization: Bearer {darklab_hcloud_token}"'
	        f" 'https://api.hetzner.cloud/v1/{args.object}'"
        ),shell=True, check=True)
    case Actions.terraform_init:
        subprocess.run((
            f"""cd tf/{args.environment} && terraform init \
            -backend-config="address=https://gitlab.com/api/v4/projects/{darklab_infra_project_id}/terraform/state/{args.environment}" \
            -backend-config="lock_address=https://gitlab.com/api/v4/projects/{darklab_infra_project_id}/terraform/state/{args.environment}/lock" \
            -backend-config="unlock_address=https://gitlab.com/api/v4/projects/{darklab_infra_project_id}/terraform/state/{args.environment}/lock" \
            -backend-config="username={darklab_gitlab_user}" \
            -backend-config="password={darklab_gitlab_apikey}" \
            -backend-config="lock_method=POST" \
            -backend-config="unlock_method=DELETE" \
            -backend-config="retry_wait_min=5"
            """
        ),shell=True, check=True)
    case Actions.cloudflare_check:
        subprocess.run((f"""
        curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
        -H "Authorization: Bearer {darklab_cloudflare_token}" \
        -H "Content-Type:application/json"
        """
            ),shell=True, check=True)
    case Actions.deploy:
        subprocess.run(f"""
        cd tf/{args.environment}
         && terraform plan
         && terraform apply -auto-approve
         && cd ../../playbooks
         && ansible-playbook -i hosts.yml deploy_ci.yml
         && skaffold -f skaffold.gitlab.yaml
         && skaffold -f skaffold.github.yaml
        """.replace("\n",""),shell=True, check=True)


    
	

