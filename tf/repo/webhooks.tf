locals {
    repos = tomap({
    darklint = {
      full_name = "darklab8/fl-darklint"
      name      = "fl-darklint"
    }
    darkstat  = { full_name = "darklab8/fl-darkstat", name = "fl-darkstat", webhook_url_commits=data.external.issues_webhook.result.url_commits_darkstat }
    darkmap   = { full_name = "darklab8/fl-darkmap", name = "fl-darkmap", webhook_url_commits=data.external.issues_webhook.result.url_commits_darkmap }
    darkcore  = { full_name = "darklab8/fl-darkcore", name = "fl-darkcore" }
    darkrelay = { full_name = "darklab8/fl-darkrelay", name = "fl-darkrelay" }
    darkbot   = { full_name = "darklab8/fl-darkbot", name = "fl-darkbot", webhook_url_commits=data.external.issues_webhook.result.url_commits_darkbot }
    configs   = { full_name = "darklab8/fl-configs", name = "fl-configs" }
  })
}

data "external" "issues_webhook" {
  program = ["pass", "personal/terraform/github/darklab8/webhooks"]
}

resource "github_repository_webhook" "for_issues" {
  for_each = local.repos

  repository = each.value.name

  configuration {
    url          = data.external.issues_webhook.result.url_issues
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["issues"]
}

# push, release

resource "github_repository_webhook" "for_commits" {
  for_each = local.repos

  repository = each.value.name

  configuration {
    url          = try(each.value.webhook_url_commits, data.external.issues_webhook.result.url_commits_generic)
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["push", "release"]
}
