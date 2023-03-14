resource "azurerm_storage_account" "this" {
  name                = local.name
  resource_group_name = var.resource_group_name
  location            = var.location

  access_tier              = var.access_tier
  account_tier             = var.account_tier
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type

  min_tls_version = var.min_tls_version

  shared_access_key_enabled       = var.shared_access_key_enabled
  large_file_share_enabled        = var.large_file_share_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication

  ##
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  enable_https_traffic_only        = var.enable_https_traffic_only

  ##

  is_hns_enabled = var.hns_enabled
  nfsv3_enabled  = var.nfsv3_enabled
  sftp_enabled   = var.sftp_enabled

  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled


  dynamic "identity" {
    for_each = var.identity_type == null ? [] : ["enabled"]
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids == "UserAssigned" ? var.identity_ids : null
    }
  }

  dynamic "blob_properties" {
    for_each = (
      var.account_kind != "FileStorage" && (var.storage_blob_data_protection != null) ? ["enabled"] : []
    )

    content {
      change_feed_enabled = var.nfsv3_enabled ? false : var.storage_blob_data_protection.change_feed_enabled
      versioning_enabled  = var.nfsv3_enabled ? false : var.storage_blob_data_protection.versioning_enabled

      dynamic "cors_rule" {
        for_each = var.storage_blob_cors_rule != null ? ["enabled"] : []
        content {
          allowed_headers    = var.storage_blob_cors_rule.allowed_headers
          allowed_methods    = var.storage_blob_cors_rule.allowed_methods
          allowed_origins    = var.storage_blob_cors_rule.allowed_origins
          exposed_headers    = var.storage_blob_cors_rule.exposed_headers
          max_age_in_seconds = var.storage_blob_cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.storage_blob_data_protection.delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.delete_retention_policy_in_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.storage_blob_data_protection.container_delete_retention_policy_in_days > 0 ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days
        }
      }

      dynamic "restore_policy" {
        for_each = local.pitr_enabled ? ["enabled"] : []
        content {
          days = var.storage_blob_data_protection.container_delete_retention_policy_in_days - 1
        }
      }
    }
  }

  tags = merge(var.default_tags, var.extra_tags)
}

##############################################################################
# TO DO Blocks
#custom_domain - (Optional) A custom_domain block as documented below.
#customer_managed_key - (Optional) A customer_managed_key block as documented below.
#queue_properties
#static_website
#share_properties
#routing 
#sas_policy


