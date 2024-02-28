provider "hcloud" {
  token = var.ci_hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}