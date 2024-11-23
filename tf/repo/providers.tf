# https://registry.terraform.io/providers/integrations/github/latest/docs
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">=6.3.1"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">=17.6.0"
    }
  }
}

data "external" "terraform_darklab_token" {
  program = ["pass", "personal/terraform/github/terraform_darklab_token"]
}

provider "github" {
  token = data.external.terraform_darklab_token.result["token"] # or `GITHUB_TOKEN`
  owner = "darklab8"
}

data "external" "terraform_gitlab_token" {
  program = ["pass", "personal/terraform/gitlab/terraform_darklab_token"]
}

provider "gitlab" {
  token = data.external.terraform_gitlab_token.result["token"]
}
