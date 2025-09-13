module "folder_applications_public" {
  source    = "./grafana_folder"
  title     = "APPLICATIONS_PUBLIC"
  uid       = "applications_public"
  is_public = true
}
