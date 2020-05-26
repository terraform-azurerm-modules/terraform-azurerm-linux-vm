variable "name" {
  description = "Name for a single VM. Use 'names' for multiple VMs. "
  type        = string
  default     = ""
}

variable "names" {
  description = "List of VMs names. Has precedence over `name`."
  type        = list(string)
  default     = []
}

variable "source_image_id" {
  description = "Custom virtual image ID. Use either this or specify the source image_reference for platform images."
  type        = string
  default     = null
}

variable "source_image_reference" {
  description = "Standard image reference block for platform images. Do not use if specifying a custom source_image_id."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = null

}

variable "availability_set_id" {
  description = "Resource ID for avaailability set."
  type        = string
  default     = null
}

variable "application_security_group_name" {
  description = "Availability set name. Can take string or list."
  type        = any
  default     = ""
}

variable "defaults" {
  description = "Collection of default values."
  type = object({
    module_depends_on    = list(string)
    resource_group_name  = string
    location             = string
    tags                 = map(string)
    key_vault_id         = string
    boot_diagnostics_uri = string

    admin_username       = string
    ssh_users            = list(string)
    subnet_id            = string
    vm_size              = string
    storage_account_type = string
  })
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Azure tags object."
  type        = map
  default     = {}
}

variable "subnet_id" {
  description = "Resource ID for the subnet to attach the NIC to."
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Virtual machine SKU name."
  type        = string
  default     = ""
}

variable "storage_account_type" {
  description = "Either Standard_LRS (default), StandardSSD_LRS or Premium_LRS."
  type        = string
  default     = ""
}

variable "key_vault_id" {
  description = "Resource ID for key_vault_id containing public SSH keys."
  type        = string
  default     = ""
}

variable "admin_username" {
  description = "Admin username. Requires matching secret in keyvault with the public key."
  type        = string
  default     = ""
}

variable "ssh_users" {
  description = "List of additional key vault secrets containing SSH public keys"
  type        = list(string)
  default     = []
}

variable "boot_diagnostics_uri" {
  description = "Blob URI for the boot diagnostics storage account."
  type        = string
  default     = ""
}

variable "module_depends_on" {
  type    = list(string)
  default = []
}
