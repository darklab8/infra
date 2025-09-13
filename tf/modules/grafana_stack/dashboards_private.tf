module "folder_private" {
  source    = "./grafana_folder"
  title     = "PRIVATE"
  uid       = "private"
  is_public = false
}
