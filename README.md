# Azure Storage Account
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/storage-account/azurerm/)

Common Azure terraform module to create a Storage Account and manage related parameters (Threat protection, Network Rules, Blob Containers, File Shares, etc.)

## Azure File share authentication

If you need to enable Active Directory or AAD DS authentication for Azure File on this Storage Account, please read the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable) and set the required values in the `file_share_authentication` variable.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 1.x.x       | 1.3.x             | >= 3.0          |

## Usage


```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

# module "logs" {
#   source  = "claranet/run-common/azurerm//modules/logs"
#   version = "x.x.x"

#   client_name         = var.client_name
#   environment         = var.environment
#   stack               = var.stack
#   location            = module.azure_region.location
#   location_short      = module.azure_region.location_short
#   resource_group_name = module.rg.resource_group_name
# }

module "storage_account" {
  source  = "claranet/storage-account/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  account_replication_type = "LRS"

  storage_blob_data_protection = {
    change_feed_enabled                       = true
    versioning_enabled                        = true
    delete_retention_policy_in_days           = 42
    container_delete_retention_policy_in_days = 42
    container_point_in_time_restore           = true
  }

  # disabled by default
  storage_blob_cors_rule = {
    allowed_headers    = ["*"]
    allowed_methods    = ["GET", "HEAD"]
    allowed_origins    = ["https://example.com"]
    exposed_headers    = ["*"]
    max_age_in_seconds = 3600
  }

  logs_destinations_ids = [
    # module.logs.logs_storage_account_id,
    # module.logs.log_analytics_workspace_id
  ]

  # Set by default
  queue_properties_logging = {
    delete                = true
    read                  = true
    write                 = true
    version               = "1.0"
    retention_policy_days = 10
  }

  containers = [
    {
      name = "bloc1"
    },
    {
      name                  = "bloc2"
      container_access_type = "blob"
    }
  ]

  file_shares = [
    {
      name        = "share1smb"
      quota_in_gb = 50
    }
  ]

  file_share_authentication = {
    directory_type = "AADDS"
  }

  tables = [
    {
      name = "table1"
    }
  ]

  queues = [
    {
      name = "mystoragequeue"
    }
  ]

  extra_tags = {
    foo = "bar"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.36 |

## Modules

| Name | Source | Version |
|------|--------|---------|


## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurecaf_name.sa](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_tier | Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`. | `string` | `"Hot"` | no |
| account\_kind | Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to StorageV2. | `string` | `"StorageV2"` | no |
| account\_replication\_type | Defines the type of replication to use for this Storage Account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. | `string` | `"ZRS"` | no |
| account\_tier | Defines the Tier to use for this Storage Account. Valid options are `Standard` and `Premium`. For `BlockBlobStorage` and `FileStorage` accounts only `Premium` is valid. Changing this forces a new resource to be created. | `string` | `"Standard"` | no |
| advanced\_threat\_protection\_enabled | Boolean flag which controls if advanced threat protection is enabled, see [documentation](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| allowed\_cidrs | List of CIDR to allow access to that Storage Account. | `list(string)` | `[]` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| containers | List of objects to create some Blob containers in this Storage Account. | <pre>list(object({<br>    name                  = string<br>    container_access_type = optional(string)<br>    metadata              = optional(map(string))<br>  }))</pre> | `[]` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_domain\_name | The Custom Domain Name to use for the Storage Account, which will be validated by Azure. | `string` | `null` | no |
| default\_firewall\_action | Which default firewalling policy to apply. Valid values are `Allow` or `Deny`. | `string` | `"Deny"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Additional tags to associate with your Azure Storage Account. | `map(string)` | `{}` | no |
| file\_share\_authentication | Storage Account file shares authentication configuration. | <pre>object({<br>    directory_type = string<br>    active_directory = optional(object({<br>      storage_sid         = string<br>      domain_name         = string<br>      domain_sid          = string<br>      domain_guid         = string<br>      forest_name         = string<br>      netbios_domain_name = string<br>    }))<br>  })</pre> | `null` | no |
| file\_share\_cors\_rules | Storage Account file shares CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information. | <pre>object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  })</pre> | `null` | no |
| file\_share\_properties\_smb | Storage Account file shares smb properties. | <pre>object({<br>    versions                        = optional(list(string), null)<br>    authentication_types            = optional(list(string), null)<br>    kerberos_ticket_encryption_type = optional(list(string), null)<br>    channel_encryption_type         = optional(list(string), null)<br>    multichannel_enabled            = optional(bool, null)<br>  })</pre> | `null` | no |
| file\_share\_retention\_policy\_in\_days | Storage Account file shares retention policy in days. | `number` | `null` | no |
| file\_shares | List of objects to create some File Shares in this Storage Account. | <pre>list(object({<br>    name             = string<br>    quota_in_gb      = number<br>    enabled_protocol = optional(string)<br>    metadata         = optional(map(string))<br>    acl = optional(list(object({<br>      id          = string<br>      permissions = string<br>      start       = optional(string)<br>      expiry      = optional(string)<br>    })))<br>  }))</pre> | `[]` | no |
| hns\_enabled | Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 and must be `true` if `nfsv3_enabled` is set to `true`. Changing this forces a new resource to be created. | `bool` | `false` | no |
| https\_traffic\_only\_enabled | Boolean flag which forces HTTPS if enabled. | `bool` | `true` | no |
| identity\_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account. | `list(string)` | `null` | no |
| identity\_type | Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both). | `string` | `"SystemAssigned"` | no |
| location | Azure location | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| min\_tls\_version | The minimum supported TLS version for the Storage Account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. | `string` | `"TLS1_2"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| network\_bypass | Specifies whether traffic is bypassed for 'Logging', 'Metrics', 'AzureServices' or 'None'. | `list(string)` | <pre>[<br>  "Logging",<br>  "Metrics",<br>  "AzureServices"<br>]</pre> | no |
| network\_rules\_enabled | Boolean to enable Network Rules on the Storage Account, requires `network_bypass`, `allowed_cidrs`, `subnet_ids` or `default_firewall_action` correctly set if enabled. | `bool` | `true` | no |
| nfsv3\_enabled | Is NFSv3 protocol enabled? Changing this forces a new resource to be created. | `bool` | `false` | no |
| public\_nested\_items\_allowed | Allow or disallow nested items within this Account to opt into being public. | `bool` | `false` | no |
| queue\_properties\_logging | Logging queue properties | <pre>object({<br>    delete                = optional(bool, true)<br>    read                  = optional(bool, true)<br>    write                 = optional(bool, true)<br>    version               = optional(string, "1.0")<br>    retention_policy_days = optional(number, 10)<br>  })</pre> | `{}` | no |
| queues | List of objects to create some Queues in this Storage Account. | <pre>list(object({<br>    name     = string<br>    metadata = optional(map(string))<br>  }))</pre> | `[]` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| shared\_access\_key\_enabled | Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). | `bool` | `true` | no |
| stack | Project stack name | `string` | n/a | yes |
| static\_website\_config | Static website configuration. Can only be set when the `account_kind` is set to `StorageV2` or `BlockBlobStorage`. | <pre>object({<br>    index_document     = optional(string)<br>    error_404_document = optional(string)<br>  })</pre> | `null` | no |
| storage\_account\_custom\_name | Custom Azure Storage Account name, generated if not set | `string` | `""` | no |
| storage\_blob\_cors\_rule | Storage Account blob CORS rule. Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule) for more information. | <pre>object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  })</pre> | `null` | no |
| storage\_blob\_data\_protection | Storage account blob Data protection parameters. | <pre>object({<br>    change_feed_enabled                       = optional(bool, false)<br>    versioning_enabled                        = optional(bool, false)<br>    delete_retention_policy_in_days           = optional(number, 0)<br>    container_delete_retention_policy_in_days = optional(number, 0)<br>    container_point_in_time_restore           = optional(bool, false)<br>  })</pre> | <pre>{<br>  "change_feed_enabled": true,<br>  "container_delete_retention_policy_in_days": 30,<br>  "container_point_in_time_restore": true,<br>  "delete_retention_policy_in_days": 30,<br>  "versioning_enabled": true<br>}</pre> | no |
| subnet\_ids | Subnets to allow access to that Storage Account. | `list(string)` | `[]` | no |
| tables | List of objects to create some Tables in this Storage Account. | <pre>list(object({<br>    name = string<br>    acl = optional(list(object({<br>      id          = string<br>      permissions = string<br>      start       = optional(string)<br>      expiry      = optional(string)<br>    })))<br>  }))</pre> | `[]` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_subdomain | Should the Custom Domain Name be validated by using indirect CNAME validation? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| storage\_account\_id | Created Storage Account ID |
| storage\_account\_identity | Created Storage Account identity block |
| storage\_account\_name | Created Storage Account name |
| storage\_account\_network\_rules | Network rules of the associated Storage Account |
| storage\_account\_properties | Created Storage Account properties |
| storage\_blob\_containers | Created blob containers in the Storage Account |
| storage\_file\_queues | Created queues in the Storage Account |
| storage\_file\_shares | Created file shares in the Storage Account |
| storage\_file\_tables | Created tables in the Storage Account |
<!-- END_TF_DOCS -->
