locals {
  public_repositories = tomap({
    darklint = {
      full_name = "darklab8/fl-darklint"
      name      = "fl-darklint"
    }
    darkstat = {
      name                = "fl-darkstat"
      description         = "Static site generator for Freeancer Discovery community to provide info about game stuff for players"
      webhook_url_commits = data.external.issues_webhook.result.url_commits_darkstat
    }
    darkmap = {
      name                = "fl-darkmap",
      webhook_url_commits = data.external.issues_webhook.result.url_commits_darkmap
    }
    darkcore = {
      name = "fl-darkcore"
    }
    darkrelay = {
      name = "fl-darkrelay"
    }
    darkbot = {
      name                = "fl-darkbot"
      description         = "discord bot to freelancer discovery community for player bases, players and forum messages tracking with alerting."
      webhook_url_commits = data.external.issues_webhook.result.url_commits_darkbot
    }
    configs = {
      name        = "fl-configs"
      description = "ORM data accessing lib for Freelancer game configs"
    }
    ctrlv = {
      name        = "fl-ctrlv"
      description = "Make Ctrl-V work for Freelancer(2003) game"
    }
  })
}

data "gitlab_group" "darklab" {
  full_path = "darklab8"
}

module "public_repositories" {
  for_each        = local.public_repositories
  description     = try(each.value.description, "")
  source          = "./repository"
  name            = each.value.name
  public          = true
  group_gitlab_id = data.gitlab_group.darklab.id
}
