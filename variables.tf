# Common

variable "location_short" {
  description = "Short string for Azure location"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

## Storage account parameters
variable "account_tier" {
  description = "Defines the Tier to use for this Storage Account. Valid options are `Standard` and `Premium"
  type        = string
  default     = "Standard"
}

variable "account_kind" {
  description = <<DESC
  Defines the Kind of account.
  For Account Tier Standard only StorageV2 is supported.
  For Account Tier Premium valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`.
  Changing this forces a new resource to be created
  DESC
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`"
  type        = string
  default     = "Hot"
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled?"
  type        = bool
  default     = false
}

variable "enable_https_traffic_only" {
  description = "Boolean flag which forces HTTPS if enabled"
  type        = bool
  default     = true
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`."
  type        = string
  default     = "LRS"
}

variable "public_network_access_enabled" {
  description = "Wheter the public network access is enabled"
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the Storage Account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. "
  type        = string
  default     = "TLS1_2"
}

variable "default_to_oauth_authentication" {
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account."
  type        = bool
  default     = false
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)."
  type        = bool
  default     = true
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 and must be `true` if `nfsv3_enabled` is set to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

# Identity
variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. Mandatory if UserAssigned Identity has been chosen"
  type        = list(string)
  default     = null
}

variable "sftp_enabled" {
  description = "Enables SFTP for the storage account. Requires HNS"
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = ""
  type        = bool
  default     = false
}

variable "queue_encryption_key_type" {
  description = "The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created."
  type        = string
  default     = "Service"
}

variable "table_encryption_key_type" {
  description = "The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created"
  type        = string
  default     = "Service"
}

variable "infrastructure_encryption_enabled" {
  description = " Is infrastructure encryption enabled? Changing this forces a new resource to be created."
  default     = false
}

// Data protection

variable "storage_blob_data_protection" {
  description = "Storage account blob Data protection parameters."
  type = object({
    change_feed_enabled                       = optional(bool, false)
    versioning_enabled                        = optional(bool, false)
    delete_retention_policy_in_days           = optional(number, 0)
    container_delete_retention_policy_in_days = optional(number, 0)
    container_point_in_time_restore           = optional(bool, false)
  })
  default = {
    change_feed_enabled                       = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 30
    container_delete_retention_policy_in_days = 30
    container_point_in_time_restore           = true
  }
}

variable "storage_blob_cors_rule" {
  description = "Storage Account blob CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information."
  type = object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  })
  default = null
}

// Not relevant in our case Threat protection is enabled at the subscription level
#variable "advanced_threat_protection_enabled" {
#  description = "Boolean flag which controls if advanced threat protection is enabled, see [documentation](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
#  type        = bool
#  default     = false
#}

# Data creation/bootstrap

variable "containers" {
  description = "List of objects to create some Blob containers in this Storage Account."
  type = list(object({
    name                  = string
    container_access_type = optional(string)
    metadata              = optional(map(string))
  }))
  default = []
}


// Not relevant as we are focusing on Blob containers only
#variable "file_shares" {
#  description = "List of objects to create some File Shares in this Storage Account."
#  type = list(object({
#    name             = string
#    quota_in_gb      = number
#    enabled_protocol = optional(string)
#    metadata         = optional(map(string))
#    acl = optional(list(object({
#      id          = string
#      permissions = string
#      start       = optional(string)
#      expiry      = optional(string)
#    })))
#  }))
#  default = []
#}
#
#variable "tables" {
#  description = "List of objects to create some Tables in this Storage Account."
#  type = list(object({
#    name = string
#    acl = optional(list(object({
#      id          = string
#      permissions = string
#      start       = optional(string)
#      expiry      = optional(string)
#    })))
#  }))
#  default = []
#}
#
#variable "queues" {
#  description = "List of objects to create some Queues in this Storage Account."
#  type = list(object({
#    name     = string
#    metadata = optional(map(string))
#  }))
#  default = []
#}
#
#variable "queue_properties_logging" {
#  description = "Logging queue properties"
#  type = object({
#    delete                = optional(bool, true)
#    read                  = optional(bool, true)
#    write                 = optional(bool, true)
#    version               = optional(string, "1.0")
#    retention_policy_days = optional(number, 10)
#  })
#  default = {}
#}
#