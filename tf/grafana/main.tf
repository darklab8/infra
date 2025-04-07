module "stack" {
  source              = "../modules/grafana_stack"
  discord_webhook_url = data.external.secrets.result["discord_webhook_url"]
}
