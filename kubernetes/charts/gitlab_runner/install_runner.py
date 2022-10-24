import argparse
import os
import base64

def shell(cmd):
    print(cmd)
    status_code = os.system(cmd)
    
    if status_code != 0:
        raise Exception(f"Non zero exit code = {status_code}")

# Create the parser
my_parser = argparse.ArgumentParser(description='')

# Add the arguments
my_parser.add_argument('gitlab_runner_registry_token',
                       type=str,
                       help='token')

# Execute the parse_args() method
args = my_parser.parse_args()


# helm repo add gitlab https://charts.gitlab.io
# helm repo update
# gQ6oRUQYRMPFPyzSzHX4
registrational_token_base64 = str(base64.b64encode((args.gitlab_runner_registry_token).encode("utf-8")),"utf-8")
print(registrational_token_base64)
# kubectl config set-context --current --namespace=
shell(f'helm upgrade --install --create-namespace --namespace gitlab-runner gitlab-secret . --set super_secret_token="{registrational_token_base64}"')
shell(f"helm upgrade --install --create-namespace --namespace gitlab-runner -f gitlab.yaml gitlab-runner gitlab/gitlab-runner")