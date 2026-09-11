terraform {
  required_version = ">= 1.5, <2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, <7.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  backend "s3" {}
}

provider "aws" {
  profile = "quota_endpoint_dev"
  region  = "eu-west-2"
}

provider "aws" {
  alias   = "product_role"
  profile = "quota_endpoint_dev"
  region  = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::160669536848:role/quota-endpoint-api-gateway"
  }
}

provider "aws" {
  alias   = "test_role"
  profile = "quota_endpoint_dev"
  region  = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::160669536848:role/test-api-gateway"
  }
}

data "terraform_remote_state" "pre_deploy" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    region = var.tf_state_region
    profile = var.tf_state_profile
key    = "steve/pre_deploy/terraform.tfstate"
  }
}
