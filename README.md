
SingleLinuxVM
This repository provides Terraform scripts for provisioning a single Linux virtual machine on Azure. It simplifies the process of creating and managing cloud infrastructure.

Table of Contents
Prerequisites
Usage
Configuration
Resources Created
License
Contributing
Prerequisites
Terraform (v1.x or later)
An active Azure account
Azure CLI installed and configured
Usage
Clone the repository:

bash
Copy code
git clone https://github.com/puspender01/SingleLinuxVM.git
cd SingleLinuxVM
Configure your Azure credentials:

Ensure that you are logged into your Azure account:

bash
Copy code
az login
Initialize Terraform:

Run the following command to initialize the Terraform configuration:

bash
Copy code
terraform init
Plan your deployment:

Review the changes that will be made:

bash
Copy code
terraform plan
Apply the configuration:

Create the resources defined in your Terraform files:

bash
Copy code
terraform apply
Type yes when prompted to confirm.

Access your VM:

Once the deployment is complete, you can SSH into your Linux VM using the public IP address displayed in the output.

Configuration
You can customize the following variables in the variables.tf file:

vm_size: Size of the virtual machine (e.g., Standard_DS1_v2).
admin_username: The username for the admin account.
admin_password: The password for the admin account.
Resources Created
The following Azure resources are created:

A resource group
A virtual network
A subnet
A network interface
A public IP address
A Linux virtual machine
License
This project is licensed under the MIT License. See the LICENSE file for details.

Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or suggestions.

Feel free to modify any sections as needed!
