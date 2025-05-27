data "hcloud_ssh_key" "darklab" {
  name       = "darklab_key"
}

output "id" {
  value = data.hcloud_ssh_key.darklab.id
}

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}
