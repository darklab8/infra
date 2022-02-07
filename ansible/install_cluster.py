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
    exit(os.system(cmd))

shell("ansible-playbook -i hosts.yml install_cluster.yml")

