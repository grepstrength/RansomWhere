output "resource_group_name" {
  description = "Resource group holding the lab. Used in the az bastion commands."
  value       = azurerm_resource_group.main.name
}

output "vm_private_ip" {
  description = "The Kali VM's private IP. No public IP exists by design."
  value       = azurerm_network_interface.vm.private_ip_address
}

output "vm_name" {
  description = "The Kali VM resource name."
  value       = azurerm_linux_virtual_machine.kali.name
}

output "bastion_name" {
  description = "The Bastion host name. Needed for every az bastion command."
  value       = azurerm_bastion_host.main.name
}
output "bastion_ssh_command" {
  description = "Copy-paste to SSH in via Bastion (key-based, native client)."
  value = join(" ", [
    "az network bastion ssh",
    "--name ${azurerm_bastion_host.main.name}",
    "--resource-group ${azurerm_resource_group.main.name}",
    "--target-resource-id ${azurerm_linux_virtual_machine.kali.id}",
    "--auth-type ssh-key",
    "--username ${var.admin_username}",
    "--ssh-key <PATH_TO_YOUR_PRIVATE_KEY>",
  ])
}
output "bastion_rdp_command" {
  description = "Copy-paste to RDP in via Bastion (after you set a password with passwd)."

  value = join(" ", [
    "az network bastion rdp",
    "--name ${azurerm_bastion_host.main.name}",
    "--resource-group ${azurerm_resource_group.main.name}",
    "--target-resource-id ${azurerm_linux_virtual_machine.kali.id}",
  ])
}