
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

Cluster is created
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/Cluster.PNG)

```bash
aws eks update-kubeconfig --region <region_name> --name <cluster_name>
```

## 2. Deploy NGINX using Kubernetes manifests

Plese find the .yaml files related to nginx deployment, service 
```bash
cd manifests
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service-nodeport.yaml  # this is using Nodeport service
kubectl get svc                               # services will be shown
```

## 3. Setup ArgoCD on EKS 
```bash

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/ArgoCD_Deployed.PNG)
Get ArgoCD admin password:
```bash

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

```
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/ArgoCD_Login.PNG)

Apply the ArgoCD app config:

```bash

kubectl apply -f argocd/nginx-app.yaml -n argocd
```
It will sync your manifests/ folder and deploy NGINX.
![Example Image](https://github.com/vijaysinga/TEST/blob/master/Images/Nginx-app_ArgoCD.PNG)



## 4. Access the NGINX App
NGINX Deployed and can be accessed through Load Balancer
```bash

kubectl apply -f manifests/nginx-service-ELB.yaml     # Using Load balancer service
kubectl get svc nginx-service                
```

