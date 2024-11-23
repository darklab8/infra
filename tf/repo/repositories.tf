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
    infra = {
      name        = "infra"
      description = "Central infrastructure repository for cluster setup and reusable infra code"
    }
    blog     = { name = "blog", description = "Personal web site", homepage_url = "https://darklab8.github.io/blog/" }
    go_utils = { name = "go-utils", description = "shared lib for golang stuff that is too small for dedicated lib" }

    fl-files-discovery = { name = "fl-files-discovery", public = false }
    fl-files-vanilla   = { name = "fl-files-vanilla", public = false }
    fl-data-discovery = {
      name         = "fl-data-discovery"
      description  = "fl-darkstat deployment for Freelancer Discovery"
      homepage_url = "https://darklab8.github.io/fl-data-discovery/"
    }
    fl-data-vanilla = {
      name         = "fl-data-vanilla",
      description  = "fl-darkstat deployment for Freelancer Vanilla"
      homepage_url = "https://darklab8.github.io/fl-data-vanilla/"
    }
    infra_game_servers = { name = "infra-game-servers" }
    autogit            = { name = "autogit", description = "Automated git conventional commits and semantic versioning" }
    examples           = { name = "examples", public = false }
    go-typelog         = { name = "go-typelog", description = "Static typed structured logging lib" }
    py-typelog         = { name = "py-typelog", description = "Static typed structured logging lib" }
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
  public          = try(each.value.public, true)
  group_gitlab_id = data.gitlab_group.darklab.id
  homepage_url    = try(each.value.homepage_url, null)
}
