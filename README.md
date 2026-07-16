

# RansomWhere!

**Build your own VM to quickly visit !**

This uses a single Kali Linux VM 

## Configurations

- **Cloud & IaC**: Azure provisioned with Terraform 
- **Network**: Single VNet (`10.0.0.0/16`); VMs on snet-vms (`10.0.1.0/24`); Bastion on AzureBastionSubnet (`10.0.2.0/26`)
- **VMs**: 2x Windows Server 2022 Datacenter with the Azure image `Standard_D4s_v5`, no public IPs
- **Attack VM**: Ollama + `FableForge-AI/mythos-v2-8b` (swap to your preference)
- **Victim VM**: OpenClaw + Ollama + `llama3.2:3b` (swap to your preference)
- **Access**: Accessible via Bastion host with a basic SKU, with browser-based RDP
- **Auth**: Azure identity via `az login`. Both the subscription and admin password are stored via environment variables... no credentials in code 

## Terraform Setup

**⚠️ At the time of development, the most recent Kali VM was `kali-2026-2`. Depending on when you try to `apply`, this may be obsolete. 

To get the currently offered kali images, run the below command and take the value from the SKU column, then enter it in `proviers.tf > resource "azurerm_marketplace_agreement" > plan`:

```powershell
az vm image list --publisher kali-linux --offer kali --all --output table
```

To run:
```powershell
terraform init      # download providers, one-time setup
terraform fmt       # format the .tf files
terraform validate  # check syntax and references
terraform apply     # build the lab (type yes to confirm)
```

## Post-Deployment Setup Instructions



### Destroy the lab
Of course, when done, just run:
```powershell
terraform destroy
```

## License 
MIT, because you're doing all the work. 