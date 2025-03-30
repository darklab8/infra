resource "gitlab_project" "project" {
  name                            = var.name
  description                     = var.description
  restrict_user_defined_variables = true

  visibility_level = var.public ? "public" : "private"
  namespace_id     = var.group_gitlab_id
}

resource "github_repository" "project" {
  name        = var.name
  description = var.description

  archived      = var.archived
  private       = !var.public
  has_issues    = true
  has_downloads = true
  homepage_url  = var.homepage_url

  dynamic "pages" {
    for_each = var.public ? { pages = {} } : {}
    content {
      build_type = "workflow"
    }
  }

  lifecycle {
    ignore_changes = [
      "pages[0].source",
    ]
  }
}

resource "github_actions_secret" "secret" {
  for_each = var.secrets

  repository      = github_repository.project.name
  secret_name     = each.key
  plaintext_value = each.value
}
