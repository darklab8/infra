module "ssh_key" {
   source       = "../modules/hetzner_ssh_key"
}

data "aws_ssm_parameter" "hetzner" {
  name = "/terraform/hetzner/production"
}
