terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.journal.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.journal.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.journal.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.journal.kube_config[0].cluster_ca_certificate)
}

resource "azurerm_resource_group" "journal" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "journal" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.journal.location
  resource_group_name = azurerm_resource_group.journal.name
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.journal.kube_config_raw
  sensitive = true
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.journal.name
}
