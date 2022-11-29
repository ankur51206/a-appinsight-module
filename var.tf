variable "sub_map" {
  type = map 
  default = {
    eastus2 = {
      hub = ""
      sec = ""
      parent = {
        prod = ""
        dev  = ""
      }
    }
  }
}
variable "parent_map" {
  type = map 
  default = {
    pr      = "prod"
    ut      = "dev"
    st      = "dev"
    pp      = "prod"
    nonprod = "dev"
  }
}
variable "loc_map" {
  type = map
  default = {
    US = {
      pri_loc = "eastus2"
      sec_loc = "centralus"
    }
    UK = {
      pri_loc = "uksouth"
      sec_loc = "ukwest"
    }
  }
}
locals {
  app_lower    = lower(var.APP_NAME)
  env_lower    = lower(var.APP_ENV)
  parent_env   = var.parent_map[local.env_lower]
  app_suffix   = "${local.app_lower}-${local.env_lower}"
  app_suffix2  = "${local.app_lower}${local.env_lower}"
  hub_id       = var.sub_map[local.pri_loc]["hub"]
  sec_id       = var.sub_map[local.pri_loc]["sec"]
  parent_id    = var.sub_map[local.pri_loc]["parent"][local.parent_env]
  # Locations
  pri_loc      = var.loc_map[var.APP_LOCATION]["pri_loc"]
  sec_loc      = var.loc_map[var.APP_LOCATION]["sec_loc"]
  # ISE SKUs
  prod_ise_sku = "Premium_0"
  dev_ise_sku  = "Developer_0"
  # on Prem App Insights
  def_onprem_name  = var.APP_ENV=="ut"?["alkmy-ut","onpremises-st"]:["onpremises-pp","onpremises-pr"]
}
variable "APP_SUB_ID" {
  description = "Subscription ID to be used for these resources. Should come from linked KV VG."
  type        = string
  default     = null
}
variable "APP_NAME" {
  description = "Name of the application"
  type        = string
}
variable "APP_ENV" {
  description = "Environment of the application. Typically, ut/st/pp/pr."
  type        = string
}
variable "APP_LOCATION" {
  description = "Location of the resources and resource group"
  type        = string
  default     = "US"
}
variable "APP_GEO" {
  description = "Flag to determine if we build geo resources. Defaults false"
  type        = bool
  default     = false
}
