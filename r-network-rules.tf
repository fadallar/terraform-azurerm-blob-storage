resource "azurerm_storage_account_network_rules" "network_rules" {
  for_each = toset(var.network_rules_enabled && !var.nfsv3_enabled ? ["enabled"] : [])

  storage_account_id = azurerm_storage_account.storage.id

  default_action             = var.default_firewall_action
  bypass                     = var.network_bypass
  ip_rules                   = local.storage_ip_rules
  virtual_network_subnet_ids = var.default_firewall_action == "Deny" ? var.subnet_ids : []
}
resource "azurerm_private_endpoint" "storageacctpep" {
  count = var.enable_private_endpoint == true ? 1 :0
  name                = format("pe-%s", local.sa_name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags = merge(var.default_tags, var.extra_tags)
  private_dns_zone_group {
    name                 = "storage-account-group"
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }

  private_service_connection {
    name                           = "storageaccountprivatelink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
  }
}