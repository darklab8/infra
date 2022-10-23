# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "ci_hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

variable "cloudflare_token" {
  sensitive = true 
}