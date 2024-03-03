terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">=1.45.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">=2.7.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=3.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">=3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    ansible = {
      source  = "ansible/ansible"
    }
  }
}

provider "hcloud" {
  token = local.secrets["HETZNER_TOKEN"]
}

data "aws_ssm_parameter" "cloudflare_key" {
  name = "/terraform/cloudflare/dd84ai"
}

provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_key.value
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "darklab"
}
