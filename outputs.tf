output "vm" {
  value = {
    for vm in azurerm_linux_virtual_machine.vm :
    vm.name => {
      "private_ip_address" = vm.private_ip_address
      "ssh_command"        = "ssh ${vm.admin_username}@${vm.private_ip_address}"
    }
  }
}