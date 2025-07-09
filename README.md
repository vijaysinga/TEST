The tasks are completed step by step as follows:
1 Terraform: Provision AWS EKS
Tools Required:
  a.AWS CLI (configured)
      * Configure the server with AWS Credentials by entering the required secret key,access key, region etc using the command "aws configure"
  b.Terraform ≥1.5.x
  c.kubectl

Prepare required main.tf, variables.tf and outputs.tf as in the terraform/main.tf, terraform/variables.tf and terraform/outputs.tf
Now go to the Terraform project where the .tf files are present and use the below commands
terraform init
terraform validate
terraform plan
terraform apply

After some time EKS Cluster will be created with the specifications mentioned in the files 
![Example Image](TEST/Images/EKS Cluster.png)
![Example Image](TEST/Images/Cluster.png)
