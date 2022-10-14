data "tfe_organization" "demo" {
  name = "nw-tfc-learn"
}

data "tfe_outputs" "demo" {
  organization = data.tfe_organization.demo.name
  workspace    = "terraform-demo-cloud-agents-aci-container-registry"
}

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
  name           = "terraform-demo-cloud-agents-aci-vm"
  organization   = var.tfc_org
  agent_pool_id  = tfe_agent_pool.demo.id
  queue_all_runs = false
  execution_mode = "agent"
  vcs_repo {
    identifier     = github_repository.demo.full_name
    oauth_token_id = tfe_oauth_client.demo.oauth_token_id
  }
}

resource "tfe_variable" "arm_tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = data.azurerm_subscription.demo.tenant_id
  category     = "env"
  workspace_id = tfe_workspace.demo.id
  sensitive    = true
}

resource "tfe_variable" "arm_subscription_id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.azurerm_subscription.demo.subscription_id
  category     = "env"
  workspace_id = tfe_workspace.demo.id
  sensitive    = true
}

resource "tfe_variable" "arm_use_msi" {
  key          = "ARM_USE_MSI"
  value        = "true"
  category     = "env"
  workspace_id = tfe_workspace.demo.id
}