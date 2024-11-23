resource "gitlab_project" "project" {
  name        = var.name
  description = var.description

  visibility_level = var.public ? "public" : "private"
  namespace_id     = var.group_gitlab_id
}

resource "github_repository" "project" {
  name        = var.name
  description = var.description

  private       = !var.public
  has_issues    = true
  has_downloads = true

  pages {
    build_type = "workflow"
  }
}
