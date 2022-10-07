resource "github_repository" "demo" {
  name        = "demo-terraform-cloud-agents-aci-virtual-machine"
  description = "Demo repo for provisioning Azure VMs using Terraform Cloud Agent running on ACI"

  visibility         = "public"
  gitignore_template = "Terraform"

  template {
    owner      = var.github_organization
    repository = var.github_template_repo
  }
}