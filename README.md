# Requirements

Probably build docker image with infra env

## microk8s 1.25
## kubectl 1.25
curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

## helm 3.10.1
curl -LO https://get.helm.sh/helm-v3.10.1-linux-amd64.tar.gz

## terraform 1.3.3

## kubens / kubectx

## yq

# Deployment:

./prepare_secrets.sh
add missing terraform_tfvars or set necessary vars as env
./make.py terraform_init
./make.py deploy ci
