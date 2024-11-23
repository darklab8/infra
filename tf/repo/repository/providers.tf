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
