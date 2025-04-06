resource "grafana_folder" "folder" {
  title = var.title
  uid   = var.uid
}

# The are the same that keycloak generates for defaults folder autocreated by web intance.
# For Tempo and Mimir folders for example.
# See them continue to match
# Technically smth autosets them, but not always, so better having defined explicitely
resource "grafana_folder_permission" "folder_permissions" {
  folder_uid = grafana_folder.folder.uid
  permissions {
    role       = "Editor"
    permission = "Edit"
  }
  permissions {
    role       = "Viewer"
    permission = "View"
  }
}
