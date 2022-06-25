import argparse
import os

# Create the parser
my_parser = argparse.ArgumentParser(description='')

# Add the arguments
my_parser.add_argument('--key',
                       type=str,
                       help='key')

# Execute the parse_args() method
args = my_parser.parse_args()

command = r"""terraform init \
     -backend-config="address=https://gitlab.com/api/v4/projects/33888063/terraform/state/cluster" \
     -backend-config="lock_address=https://gitlab.com/api/v4/projects/33888063/terraform/state/cluster/lock" \
     -backend-config="unlock_address=https://gitlab.com/api/v4/projects/33888063/terraform/state/cluster/lock" \
     -backend-config="username=dd84ai" \
     -backend-config="password={api_key}" \
     -backend-config="lock_method=POST" \
     -backend-config="unlock_method=DELETE" \
     -backend-config="retry_wait_min=5"
     """.format(api_key=args.key)

print(command)
exit(os.system(command))