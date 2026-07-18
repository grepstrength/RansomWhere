![alt text](ransomwhere.png)

# RansomWhere?

**Keep your personal infrastructure clean!**

Build your own burnable VM to safely visit ransomware data leak sites or potential phishing pages! Even if it gets compromised, a simple `terraform destroy` later and the TA gets nothing!

**STILL UNDER DEVELOPMENT**

## Configurations

- **Cloud & IaC**: Azure provisioned with Terraform 
- **VMs**: Single Kali 2026.2 VM
- **Features**: TOR Browser w/ RansomLook bookmarks to get the latest ransomware threat intel, including active .onion links
- **Access**: Accessible via Bastion host with a basic SKU, with browser-based RDP
- **Auth**: Azure identity via `az login`. Both the subscription and admin password are stored via environment variables... no credentials in code 

## Terraform Setup

*⚠️ At the time of development (July 2026), the most recent Kali VM was `kali-2026-2`. Depending on when you try to `apply`, this may be obsolete.*

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
Of course, when done (**or you get burned!!!**), just run:
```powershell
terraform destroy
```

## License 
MIT, because you're doing all the work. 