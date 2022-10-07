resource "tfe_agent_pool" "demo" {
  name         = "azure-aci-agent-pool"
  organization = var.tfc_org
}

resource "tfe_agent_token" "demo" {
  agent_pool_id = tfe_agent_pool.demo.id
  description   = "demo_agent_pool_token"
}

resource "tfe_oauth_client" "demo" {
  name             = github_repository.demo.name
  organization     = var.tfc_org
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "demo" {
  name           = "azure-agent-pool-virtual-machine-demo"
  organization   = var.tfc_org
  agent_pool_id  = tfe_agent_pool.demo.id
  queue_all_runs = false
  execution_mode = "agent"
  vcs_repo {
    identifier = github_repository.demo.full_name
    oauth_token_id = tfe_oauth_client.demo.oauth_token_id
  }
}