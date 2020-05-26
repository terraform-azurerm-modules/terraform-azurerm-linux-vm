# terraform-azurerm-linux-vm

## Description

This Terraform module creates one or more VMs. Uses a defaults object to reduce down the variables required.

> This is a WORK IN PROGRESS and will definitely change. Currently only supports custom images, doesn't integrate with availability sets or application security groups.

## Example

> CLEAN UP THE EXAMPLE TO BE A FULL STANDALONE

```terraform
locals {
  vm_defaults = {
    module_depends_on    = ["module.hub_vnet"]
    resource_group_name  = azurerm_resource_group.rg.name
    location             = azurerm_resource_group.rg.location
    tags                 = azurerm_resource_group.rg.tags
    key_vault_id         = module.shared_services.key_vault.id
    boot_diagnostics_uri = module.shared_services.diags.uri

    admin_username       = "ubuntu"
    ssh_users            = []
    subnet_id            = module.vnet.subnets["mySubnet"].id
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
  }
}

module "example_vm" {
  source          = "github.com/terraform-azurerm-modules/terraform-azurerm-linux-vm/"
  defaults        = local.vm_defaults
  name            = "example_vm"
  source_image_id = data.azurerm_image.ubuntu.id
}
```
