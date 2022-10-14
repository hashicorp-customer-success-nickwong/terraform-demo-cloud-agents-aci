variable "resource_prefix" {
  type    = string
  default = "nwong"
}

variable "location" {
  type    = string
  default = "Canada Central"
}

variable "tags" {
  type = map(string)
  default = {
    "Owner"       = "nwong"
    "Environment" = "dev"
  }
}

variable "tfc_org" {
  type    = string
  default = "nw-tfc-learn"
}

variable "github_template_repo" {
  type    = string
  default = "terraform-demo-cloud-agents-aci-vm-template"
}

variable "github_token" {
  type = string
}

variable "github_organization" {
  type    = string
  default = "hashicorp-customer-success-nickwong"
}