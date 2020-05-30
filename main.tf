locals {
  names = toset(length(var.names) > 0 ? var.names : [var.name])

  module_depends_on    = coalescelist(var.module_depends_on, var.defaults.module_depends_on)
  resource_group_name  = coalesce(var.resource_group_name, var.defaults.resource_group_name)
  location             = coalesce(var.location, var.defaults.location)
  tags                 = merge(var.defaults.tags, var.tags)
  boot_diagnostics_uri = coalesce(var.boot_diagnostics_uri, var.defaults.boot_diagnostics_uri)

  admin_username       = coalesce(var.admin_username, var.defaults.admin_username)
  admin_ssh_public_key = try(coalesce(var.admin_ssh_public_key, var.defaults.admin_ssh_public_key), file("~/.ssh/id_rsa.pub"))
  additional_ssh_keys  = try(coalesce(var.additional_ssh_keys, var.defaults.additional_ssh_keys), [])

  subnet_id            = coalesce(var.subnet_id, var.defaults.subnet_id)
  vm_size              = coalesce(var.vm_size, var.defaults.vm_size)
  storage_account_type = coalesce(var.storage_account_type, var.defaults.storage_account_type)

  vms_to_asgs = length(var.application_security_group_id) > 0 ? local.names : []

}

resource "azurerm_network_interface" "vm" {
  depends_on          = [var.module_depends_on]
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  for_each = local.names
  name     = "${each.value}-nic"

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_security_group_association" "asg" {
  for_each                      = local.vms_to_asgs
  network_interface_id          = azurerm_network_interface.vm[each.value].id
  application_security_group_id = var.application_security_group_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  for_each = local.names
  name     = each.value // also used for computer_name, i.e. hostname

  admin_username                  = local.admin_username
  disable_password_authentication = true
  size                            = local.vm_size
  availability_set_id             = var.availability_set_id
  // zone                            = 'A'

  network_interface_ids = [azurerm_network_interface.vm[each.key].id]

  /*
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  */

  source_image_id = var.source_image_id

  os_disk {
    name                 = "${each.value}-os"
    caching              = "ReadWrite"
    storage_account_type = local.storage_account_type
  }

  // custom_data = "Base64 encoded custom data"

  admin_ssh_key {
    username   = local.admin_username
    public_key = local.admin_ssh_public_key
  }

  dynamic "admin_ssh_key" {
    for_each = var.additional_ssh_keys
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = local.boot_diagnostics_uri
  }
}
