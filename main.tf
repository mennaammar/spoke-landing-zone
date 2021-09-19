terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.75.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}


resource "random_string" "prefix" {
  count   = try(var.global_settings.prefix, null) == null ? 1 : 0
  length  = 4
  special = false
  upper   = false
  number  = false
}

provider "azurerm" {
  features {}
  # credentials here 
}
data "azurerm_client_config" "current" {}
# data "azuread_service_principal" "logged_in_app" {
#   count          = try(data.azurerm_client_config.current.object_id, null) == null ? 1 : 0
#   application_id = data.azurerm_client_config.current.client_id
# }
module "resource_groups" {
  source = "./terraform-azurerm-caf/modules/resource_group"
  resource_group_name = var.resource_group_name
  settings            = var.global_settings
  global_settings     = local.global_settings
  tags                = var.tags
}



module "networking" {
  depends_on = [module.network_watchers]
  source     = "./terraform-azurerm-caf/modules/networking/virtual_network"
  for_each   = local.networking.vnets

  #application_security_groups       = local.combined_objects_application_security_groups
  client_config                     = local.client_config
  #ddos_id                           = try(azurerm_network_ddos_protection_plan.ddos_protection_plan[each.value.ddos_services_key].id, "")
  #diagnostics                       = local.combined_diagnostics
  diagnostics                       = null
  global_settings                   = local.global_settings
  network_security_groups           = module.network_security_groups
  network_security_group_definition = local.networking.network_security_group_definition
  network_watchers                  = local.combined_objects_network_watchers
  #route_tables                      = module.route_tables
  settings                          = each.value
  tags                              = try(each.value.tags, null)

 # resource_group_name = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].name
   resource_group_name = module.resource_groups.name

 # location            = lookup(each.value, "region", null) == null ? local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try( each.value.resource_group_key)].location : local.global_settings.regions[each.value.region]
  location = module.resource_groups.location
  base_tags           = try(local.global_settings.inherit_tags, false) ? local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags : {}

#   remote_dns = {
#     azurerm_firewall = try(var.remote_objects.azurerm_firewall, null) #assumed from remote lz only
#   }
}
module "network_security_groups" {
  source = "../terraform-azurerm-caf/modules/networking/network_security_group"

#   for_each = {
#     for key, value in local.networking.network_security_group_definition : key => value
#     if try(value.version, 0) == 1
#   }

  #base_tags           = try(local.global_settings.inherit_tags, false) ? local.resource_groups[each.value.resource_group_key].tags : {}
  base_tags =null
  diagnostics         = {}
  global_settings     = local.global_settings
  location            = module.resource_groups.location
  resource_group_name = module.resource_groups.name
  settings            = { name="nsg1"}
  client_config       = local.client_config

  // Module to support the NSG creation outside of the a subnet
  // version = 1 of NSG can be attached to a nic or a subnet
  // version 1 requires the name and resource_group_key as additional mandatory attributes
  // If version = 1 is not present, the nsg can onle attached to a subnet
}
module "network_watchers" {
  source   = "./terraform-azurerm-caf/modules/networking/network_watcher"
  #for_each = local.networking.network_watchers

 # resource_group_name = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].name
 resource_group_name=module.resource_groups.name
  #location            = lookup(each.value, "region", null) == null ? local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location : local.global_settings.regions[each.value.region]
  location = module.resource_groups.location
 # base_tags           = try(local.global_settings.inherit_tags, false) ? local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags : {}
 base_tags = null
  settings            = { name= "test"}
#  tags                = try(each.value.tags, null)
 tags=null
  global_settings     = local.global_settings
}