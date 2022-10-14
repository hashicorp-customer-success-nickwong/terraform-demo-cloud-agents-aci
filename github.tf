resource "github_repository" "demo" {
  name        = "terraform-demo-cloud-agents-aci-vm"
  description = "Demo repo for provisioning Azure VMs using Terraform Cloud Agent running on ACI"

  visibility         = "public"
  gitignore_template = "Terraform"

  template {
    owner      = var.github_organization
    repository = var.github_template_repo
  }
}