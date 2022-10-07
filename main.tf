terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
    github = {
      source = "integrations/github"
    }
  }
  backend "remote" {
    organization = "nw-tfc-learn"
    workspaces {
      name = "terraform-demo-cloud-agents-aci"
    }
  }
  required_version = ">=0.13"
}

provider "azurerm" {
  features {}
}

provider "github" {
  token = var.github_token
  owner = var.github_organization
}

provider "tfe" {
}




