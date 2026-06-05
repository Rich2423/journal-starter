variable "resource_group_name" {
  type    = string
  default = "rg-journal-prod"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "aks_cluster_name" {
  type    = string
  default = "aks-journal-prod"
}
