terraform {
  required_version = ">= 1.0, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0,  < 7.0"
    }
  }
}

variable "banned_workspace_names" {
  type = list(string)
  default = ["default", "production", "prod"]

  validation {
    condition     = !contains(var.banned_workspace_names, terraform.target_workspace)
    error_message = "Workspace name used ${terraform.target_workspace} is in banned workspace names: ${local.banned_workspace_names}"
  }
}
