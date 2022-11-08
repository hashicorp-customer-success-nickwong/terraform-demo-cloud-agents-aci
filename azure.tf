resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-ci-resource-group"
  location = var.location
}

resource "azurerm_user_assigned_identity" "demo" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = tfe_agent_pool.demo.name
  tags = merge(var.tags, {
    resource-type = "UserAssignedIdentity"
    resource-sku  = "None"
  })
}

resource "azurerm_container_group" "tfc-agent" {
  name                = "tfc-agent"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "None"
  os_type             = "Linux"

  image_registry_credential {
    server   = data.tfe_outputs.demo.values.login_server
    username = data.tfe_outputs.demo.values.admin_username
    password = data.tfe_outputs.demo.values.admin_password
  }

  dynamic "container" {
    for_each = range(1, var.container_count + 1)
    content {
      name   = "tfc-agent-${format("%02d", container.value)}"
      image  = "${data.tfe_outputs.demo.values.login_server}/hashicorp-customer-success-nickwong/terraform-demo-cloud-agents-aci-docker-file/terraform-cloud-agent:latest"
      cpu    = "1.0"
      memory = "2.0"

      environment_variables = {
        TFC_AGENT_NAME = "tfc-agent-${format("%02d", container.value)}"
      }

      secure_environment_variables = {
        TFC_AGENT_TOKEN = tfe_agent_token.demo.token
      }
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.demo.id
    ]
  }

  tags = merge(var.tags, {
    resource-type = "ContainerInstance"
    resource-sku  = "None"
  })
}

resource "azurerm_role_assignment" "demo" {
  scope                = data.azurerm_subscription.demo.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.demo.principal_id
}

# Assign Permissions for the managed identity
data "azurerm_subscription" "demo" {
}

