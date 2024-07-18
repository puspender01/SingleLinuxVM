# SingleLinuxVM

This repository provides Terraform scripts for provisioning a single Linux virtual machine on Azure. It simplifies the process of creating and managing cloud infrastructure.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Resources Created](#resources-created)
- [License](#license)
- [Contributing](#contributing)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.x or later)
- An active [Azure account](https://azure.microsoft.com/en-us/free/)
- Azure CLI installed and configured

## Usage

1. **Clone the repository**:

   
   git clone https://github.com/puspender01/SingleLinuxVM.git
   cd SingleLinuxVM
   

2. **Configure your Azure credentials**:

   Ensure that you are logged into your Azure account:

   
   az login
   

3. **Initialize Terraform**:

   Run the following command to initialize the Terraform configuration:

   
   terraform init
   

4. **Plan your deployment**:

   Review the changes that will be made:

   
   terraform plan
   

5. **Apply the configuration**:

   Create the resources defined in your Terraform files:

   
   terraform apply
   

   Type `yes` when prompted to confirm.

6. **Access your VM**:

   Once the deployment is complete, you can SSH into your Linux VM using the public IP address displayed in the output.
   
   or use command az vm list-ip-addresses -o table   # to display Ip addresses
## Configuration

You can customize the following variables in the `variables.tf` file:

- `vm_size`: Size of the virtual machine (e.g., `Standard_DS1_v2`).
- `admin_username`: The username for the admin account.
- `admin_password`: The password for the admin account.

## Resources Created

The following Azure resources are created:

- A resource group
- A virtual network
- A subnet
- A network interface
- A public IP address
- A Linux virtual machine


## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.

---
