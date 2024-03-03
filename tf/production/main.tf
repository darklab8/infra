module "ssh_key" {
   source       = "../modules/hetzner_ssh_key"
}

data "aws_ssm_parameter" "hetzner" {
  name = "/terraform/hetzner/darkbot/production"
}

locals {
  secrets = nonsensitive(jsondecode(data.aws_ssm_parameter.hetzner.value))
}
