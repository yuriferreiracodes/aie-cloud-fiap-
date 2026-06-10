terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "sufixo" {
  length  = 6
  upper   = false
  special = false
}

locals {
  tags = {
    aula         = "3"
    disciplina   = "cloud-cognitive"
    projeto      = "quantum-commerce"
    provisionado = "terraform"
  }
}

# Resource Group da Aula 3
resource "azurerm_resource_group" "rg" {
  name     = "rg-qc-aula03-${random_string.sufixo.result}"
  location = var.location
  tags     = local.tags
}

# Storage Account obrigatório para a Function (estado interno + logs)
resource "azurerm_storage_account" "func_sa" {
  name                     = "stfunc${random_string.sufixo.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

# Consumption Plan (Y1) — pay per execution, 1M req/mês grátis
resource "azurerm_service_plan" "plan" {
  name                = "asp-qc-aula03-${random_string.sufixo.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.tags
}

# Data source — referência ao Storage da Aula 2 (não é recriado aqui)
data "azurerm_storage_account" "aula2" {
  name                = var.storage_account_aula2
  resource_group_name = var.resource_group_aula2
}
