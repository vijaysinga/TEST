
# CI/CD Pipeline with EKS + Terraform + ArgoCD

This repository provisions an AWS EKS cluster using Terraform, deploys an NGINX application via ArgoCD, and optionally exposes it.

## Folder Structure

- `terraform/` — EKS Cluster & VPC
- `manifests/` — Kubernetes YAMLs (NGINX, Ingress)
- `argocd/` — ArgoCD application resource
- `README.md`

---

##  Getting Started

### 1. Provision EKS with Terraform
Tools Required:
 - AWS CLI (configured)
   - Configure the server with AWS Credentials by entering the required secret key,access key, region etc using the command "aws configure"
 - Terraform ≥1.5.x
 - kubectl 

Prepare required main.tf, variables.tf and outputs.tf as in the terraform/main.tf, terraform/variables.tf and terraform/outputs.tf Now go to the Terraform project where the .tf files are present and use the below commands

```bash
terraform init
terraform validate
terraform plan
terraform apply
```
After apply, configure kubeconfig:
After some time EKS Cluster will be created with the specifications mentioned in the files 

![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/EKS_Cluster.PNG)
Cluster is created
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/Cluster.PNG)
```bash
Copy
Edit
aws eks update-kubeconfig --region <region_name> --name <cluster_name>
```

## 2. Install ArgoCD
```bash
Copy
Edit
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/ArgoCD_Deployed.PNG)
Get ArgoCD admin password:
```bash
Copy
Edit
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

```
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/ArgoCD_Deployed.PNG)
## 3. ArgoCD Application
Apply the ArgoCD app config:

```bash
Copy
Edit
kubectl apply -f argocd/nginx-app.yaml -n argocd
It will sync your manifests/ folder and deploy NGINX.
```
## 4. Access the NGINX App
Via LoadBalancer: kubectl get svc nginx-service
