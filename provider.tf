terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.16"
    }
  }
}