variable "global_settings" {
  description = "Global settings object for the current deployment."
  default = {
    passthrough    = false
    random_length  = 4
    default_region = "region1"
    regions = {
      region1 = "southeastasia"
      region2 = "eastasia"
    }
  }
}
variable "network_security_group_definition"  {
  # This entry is applied to all subnets with no NSG defined
 default={
      empty_nsg = {
  }

  application_gateway = {

    nsg = [
      {
        name                       = "Inbound-HTTP",
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-HTTPs",
        priority                   = "130"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-AGW",
        priority                   = "140"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    ]
  }
 }
}
variable "remote_objects" {
  description = "Allow the landing zone to retrieve remote tfstate objects and pass them to the CAF module."
  default     = {}
}

variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}

variable "logged_user_objectId" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_objectId" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}
variable "resource_groups" {
  description = "Configuration object - Resource groups."
  default     = {}
}
variable "diagnostics" {
  description = "Configuration object - Diagnostics object."
  default     = {}
}
variable "settings" { default     = null }
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
  default="test2"
}



variable "client_config" {
  default = {}
}
variable "networking" {
  description = "Configuration object - networking resources"
  default     = {
     vnets = {
  vnet_region1 = {
    resource_group_key = "vm_region1"
    vnet = {
      name          = "virtual_machines"
      address_space = ["10.100.100.0/24"]
    }
    subnets = {
      example = {
        name = "examples"
        cidr = ["10.100.100.0/29"]
      }
    }

  }
}
     

  }
}
variable "environment" {
  description = "Name of the CAF environment."
  type        = string
  default     = "MAF"
}
variable "tags" {
  description = "Tags to be used for this resource deployment."
  type        = map(any)
  default     = null
}