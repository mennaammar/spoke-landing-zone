
locals {
  global_settings = merge({
    default_region     = try(var.global_settings.default_region, "region1")
    environment        = try(var.global_settings.environment, var.environment)
    inherit_tags       = try(var.global_settings.inherit_tags, false)
    passthrough        = try(var.global_settings.passthrough, false)
    prefix             = try(var.global_settings.prefix, null)
    prefix_with_hyphen = try(var.global_settings.prefix_with_hyphen, format("%s-", try(var.global_settings.prefix, try(var.global_settings.prefixes[0], random_string.prefix.0.result))))
    prefixes           = try(var.global_settings.prefix, null) == "" ? null : try([var.global_settings.prefix], try(var.global_settings.prefixes, [random_string.prefix.0.result]))
    random_length      = try(var.global_settings.random_length, 0)
    regions            = try(var.global_settings.regions, null)
    tags               = try(var.global_settings.tags, null)
    use_slug           = try(var.global_settings.use_slug, true)
  }, var.global_settings)

combined_objects_network_watchers                    = merge(tomap({ (local.client_config.landingzone_key) = module.network_watchers }), try(var.remote_objects.network_watchers, {}))
resource_groups = {
  test = { #resource_group_key
    name = "test"
  }
}
object_id= data.azurerm_client_config.current.object_id
#object_id = coalesce(var.logged_user_objectId, var.logged_aad_app_objectId, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app.0.object_id, null))
  client_config = var.client_config == {} ? {
    client_id               = data.azurerm_client_config.current.client_id
    landingzone_key         = var.current_landingzone_key
    logged_aad_app_objectId = local.object_id
    logged_user_objectId    = local.object_id
    object_id               = local.object_id
    subscription_id         = data.azurerm_client_config.current.subscription_id
    tenant_id               = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)
   
   
   combined_objects_resource_groups                     = merge(tomap({ (local.client_config.landingzone_key) = local.resource_groups }), try(var.remote_objects.resource_groups, {}))

  networking = {
    application_gateway_applications                        = try(var.networking.application_gateway_applications, {})
    application_gateway_applications_v1                     = try(var.networking.application_gateway_applications_v1, {})
    application_gateway_platforms                           = try(var.networking.application_gateway_platforms, {})
    application_gateway_waf_policies                        = try(var.networking.application_gateway_waf_policies, {})
    application_gateways                                    = try(var.networking.application_gateways, {})
    application_security_groups                             = try(var.networking.application_security_groups, {})
    azurerm_firewall_application_rule_collection_definition = try(var.networking.azurerm_firewall_application_rule_collection_definition, {})
    azurerm_firewall_nat_rule_collection_definition         = try(var.networking.azurerm_firewall_nat_rule_collection_definition, {})
    azurerm_firewall_network_rule_collection_definition     = try(var.networking.azurerm_firewall_network_rule_collection_definition, {})
    azurerm_firewall_policies                               = try(var.networking.azurerm_firewall_policies, {})
    azurerm_firewall_policy_rule_collection_groups          = try(var.networking.azurerm_firewall_policy_rule_collection_groups, {})
    azurerm_firewalls                                       = try(var.networking.azurerm_firewalls, {})
    azurerm_routes                                          = try(var.networking.azurerm_routes, {})
    ddos_services                                           = try(var.networking.ddos_services, {})
    dns_zone_records                                        = try(var.networking.dns_zone_records, {})
    dns_zones                                               = try(var.networking.dns_zones, {})
    domain_name_registrations                               = try(var.networking.domain_name_registrations, {})
    express_route_circuit_authorizations                    = try(var.networking.express_route_circuit_authorizations, {})
    express_route_circuits                                  = try(var.networking.express_route_circuits, {})
    front_door_waf_policies                                 = try(var.networking.front_door_waf_policies, {})
    front_doors                                             = try(var.networking.front_doors, {})
    ip_groups                                               = try(var.networking.ip_groups, {})
    load_balancers                                          = try(var.networking.load_balancers, {})
    local_network_gateways                                  = try(var.networking.local_network_gateways, {})
    nat_gateways                                            = try(var.networking.nat_gateways, {})
    network_security_group_definition                       = try(var.networking.network_security_group_definition, {})
    network_watchers                                        = try(var.networking.network_watchers, {})
    private_dns                                             = try(var.networking.private_dns, {})
    public_ip_addresses                                     = try(var.networking.public_ip_addresses, {})
    route_tables                                            = try(var.networking.route_tables, {})
    vhub_peerings                                           = try(var.networking.vhub_peerings, {})
    virtual_hub_connections                                 = try(var.networking.virtual_hub_connections, {})
    virtual_hub_er_gateway_connections                      = try(var.networking.virtual_hub_er_gateway_connections, {})
    virtual_hub_route_tables                                = try(var.networking.virtual_hub_route_tables, {})
    virtual_hubs                                            = try(var.networking.virtual_hubs, {})
    virtual_network_gateway_connections                     = try(var.networking.virtual_network_gateway_connections, {})
    virtual_network_gateways                                = try(var.networking.virtual_network_gateways, {})
    virtual_wans                                            = try(var.networking.virtual_wans, {})
    vnet_peerings                                           = try(var.networking.vnet_peerings, {})
    vnets                                                   = try(var.networking.vnets, {})
    vpn_gateway_connections                                 = try(var.networking.vpn_gateway_connections, {})
    vpn_sites                                               = try(var.networking.vpn_sites, {})
  }

}
