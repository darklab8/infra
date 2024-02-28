set -x
set -u

yq -r -o=json .secrets.yml > .secrets.json
yq -r -o=json settings.yml > settings.env.json
yq .secrets.yml | yq '.helm.darklab' > .darklab.helm.secrets.yml
yq .secrets.yml | yq '.helm.shapevpn' > .shapevpn.helm.secrets.yml
yq .secrets.yml | yq '.helm.noveo' > .noveo.helm.secrets.yml