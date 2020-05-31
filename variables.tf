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

// ==============================================================================

variable "defaults" {
  description = "Collection of user configurable default values."
  type = object({
    module_depends_on    = any
    resource_group_name  = string
    location             = string
    tags                 = map(string)
    boot_diagnostics_uri = string
    subnet_id            = string
    vm_size              = string
    storage_account_type = string
    admin_username       = string
    admin_ssh_public_key = string

    additional_ssh_keys = list(object({
      username   = string
      public_key = string
    }))
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

variable "admin_ssh_public_key" {
  description = "SSH public key string for admin_username. E.g. file(~/.ssh/id_rsa.pub)."
  type        = string
  default     = ""
}

variable "additional_ssh_keys" {
  description = "List of additional admin users and their SSH public keys"
  type = list(object({
    username   = string
    public_key = string
  }))
  default = []
}

variable "boot_diagnostics_uri" {
  description = "Blob URI for the boot diagnostics storage account."
  type        = string
  default     = ""
}

// ==============================================================================

// Feeding in the set_object from the terraform-azurerm-set object will automatically assoicate the vm with the availability set (if it exists),
// and the network interfaces with the application security group, and the load balancer backend pool.

variable "set_object" {
  description = "Output object from terraform-azurerm-set module. May include application_security_group, availability_set and azurerm_lb_backend_address_pool objects.)"
  type        = map(any)
  default     = {}
}

variable "application_security_group_id" {
  description = "Resource ID for application security group."
  type        = string
  default     = null
}

variable "availability_set_id" {
  description = "Resource ID for availability set."
  type        = string
  default     = null
}

variable "load_balancer_backend_pool_id" {
  description = "Resource ID for the load balancer's backend pool."
  type        = string
  default     = null
}

// ==============================================================================

variable "module_depends_on" {
  type    = any
  default = []
}
