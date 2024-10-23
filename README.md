
# Terraform AWS Helm Addons

This Terraform module simplifies the deployment of essential Kubernetes addons to an existing Amazon EKS (Elastic Kubernetes Service) cluster using Helm. These addons enhance the functionality, scalability, and manageability of your cluster.

## Addons Included:
- **Metrics Server**: Provides resource metrics (CPU, memory, etc.) for Kubernetes objects.
- **Cluster Autoscaler**: Automatically adjusts the number of nodes in your EKS cluster based on resource demand.
- **AWS Load Balancer Controller**: Manages AWS Elastic Load Balancers for Kubernetes services.
- **NGINX Ingress Controller**: Provides HTTP(S) routing into the Kubernetes cluster.
- **EBS CSI Driver**: Manages persistent storage for your Kubernetes workloads using AWS EBS volumes.



## Prerequisites

To use this module, ensure you have the following tools installed and properly configured:

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (with appropriate IAM permissions)
- [Helm](https://helm.sh/docs/intro/install/) >= 2.15
- An existing Amazon EKS cluster

## Module Overview

This module automates the installation and configuration of critical Kubernetes addons using Terraform and Helm. For addons that require AWS IAM roles and policies (e.g., AWS Load Balancer Controller, Cluster Autoscaler), these resources are created automatically within the module.

Each addon is modularized and configured in a separate Terraform file, making it easier to customize and manage specific addons.

### Addon Descriptions
- **Metrics Server**: Gathers resource usage statistics from nodes and pods in your cluster.
- **Cluster Autoscaler**: Scales the number of EC2 instances in the cluster based on pod scheduling needs.
- **AWS Load Balancer Controller**: Automatically creates and manages AWS Elastic Load Balancers (ALBs and NLBs).
- **NGINX Ingress Controller**: Manages external access to your services using Ingress resources.
- **EBS CSI Driver**: Allows pods to use AWS Elastic Block Store (EBS) volumes for persistent storage.



## Variables

All variables for the addons are centralized in the `6-variables.tf` file. Here’s a summary of the key variables:

- **`env`**: Environment identifier (e.g., `dev`, `staging`, `prod`).
- **`eks_name`**: Name of your Amazon EKS cluster.
- **`region`**: AWS region where your EKS cluster is running.
- **Addon-specific variables**: 
  - `cluster_autoscaler_enabled`: Enables/disables Cluster Autoscaler deployment.
  - `aws_lbc_enabled`: Enables/disables AWS Load Balancer Controller.
  - `metrics_server_enabled`: Enables/disables Metrics Server.
  - `nginx_ingress_enabled`: Enables/disables NGINX Ingress Controller.

You can pass these variables as command-line arguments or configure them in the `variables.tf` file.

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/panchanandevops/terraform-aws-helm-addons.git
cd terraform-aws-helm-addons/helm-addons
```

### 2. Initialize Terraform

Initialize the working directory to download the required providers and modules:

```bash
terraform init
```

### 3. Configure Variables

Edit the `6-variables.tf` file to adjust the configurations for your environment, or pass them as flags using the Terraform CLI:

```bash
terraform apply -var="eks_name=my-cluster" -var="region=us-west-2" -var="env=prod"
```

### 4. Deploy the Addons

To apply the configuration and deploy the Helm addons, run:

```bash
terraform apply
```

This command will:
- Install the **Metrics Server** for resource metrics.
- Deploy **Cluster Autoscaler** to automatically adjust node counts.
- Install **AWS Load Balancer Controller** with necessary IAM roles and policies.
- Install **NGINX Ingress Controller** for managing HTTP/S traffic.
- Install **EBS CSI Driver** for persistent storage in Kubernetes using EBS volumes.

### 5. Tear Down the Resources

If you need to remove the installed addons and their configurations:

```bash
terraform destroy
```

This will remove all the Helm releases and associated IAM roles and policies.

## Customizing Helm Values

Each addon has a corresponding Helm values YAML file in the `values/` directory, where you can customize configuration settings (e.g., resource limits, autoscaling configurations, service types).

To modify any addon, edit the respective YAML file:

- `aws_lbc.yaml` for AWS Load Balancer Controller
- `cluster_autoscaler.yaml` for Cluster Autoscaler
- `metrics_server.yaml` for Metrics Server
- `nginx_ingress.yaml` for NGINX Ingress Controller

Make sure the paths to these values files are correctly set in the `6-variables.tf` file.

