import argparse
import os
from jinja2 import Template
from contextlib import suppress

# Create the parser
my_parser = argparse.ArgumentParser(description='')

# Add the arguments
my_parser.add_argument('--ip',
                       type=str,
                       help='ip',
                       default="darklab.dedyn.io")

# Execute the parse_args() method
args = my_parser.parse_args()

with suppress(FileNotFoundError):
    os.remove("hosts.yml")

hosts_yml = Template("""
all:
  vars:
    ansible_user: root
    ansible_connection: ssh 
    ansible_ssh_extra_args: '-o ForwardAgent=yes'
    ansible_ssh_private_key_file: ~/.ssh/pipeline_pet_project

  children:
    microk8s_server:
      hosts:
        {{server_target}}
""")
rendered = hosts_yml.render(server_target=args.ip)

with open("hosts.yml", "w") as file_:
    file_.write(rendered)

def shell(cmd):
    print(cmd)
    return_code = os.system(cmd)
    if return_code != 0:
      raise Exception(f"exit code is not zero: {return_code}")

shell("ansible-playbook -i hosts.yml install_cluster.yml")
shell("ansible-playbook -i hosts.yml download_configs.yml")

