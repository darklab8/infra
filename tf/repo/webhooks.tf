data "external" "issues_webhook" {
  program = ["pass", "personal/terraform/github/darklab8/webhooks"]
}

resource "github_repository_webhook" "for_issues" {
  for_each = local.public_repositories

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
  for_each = local.public_repositories

  repository = each.value.name

  configuration {
    url          = try(each.value.webhook_url_commits, data.external.issues_webhook.result.url_commits_generic)
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["push", "release"]
}
