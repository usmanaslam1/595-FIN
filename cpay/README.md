# Terraform Infrastructure Deployment - Curacao Pay Offsite Payments App

This guide will walk you through deploying the Curacao Offsite Payments Infrastructure using [Terraform](https://www.terraform.io/).

## Prerequisites

- Terraform installed
- Ansible installed
- 1Password CLI Installed
- AWS CLI configured with a profile for the `curacao` account

## Installation

Install Terraform using Homebrew:

```bash
# install terraform
brew install terraform

# install 1password cli
brew install 1password-cli
```
## Environments

>Each developer that works on this project requires their own development environment. This allows deployment of developer scopes resources to AWS when working with the Serverless dev mode (see more below)

| Name     | Handle | Config
| ----------- | ----------- | ----------- | 
| Production | `production` | [Terraform Config](https://github.com/meetdomaine/curacao-offsite-payments-app/blob/develop/terraform/production.tfvars) | 
| Staging | `staging` | [Terraform Config](https://github.com/meetdomaine/curacao-offsite-payments-app/blob/develop/terraform/staging.tfvars) | 
| Development - Luke (Domaine) | `dev-luke` | [Terraform Config](https://github.com/meetdomaine/curacao-offsite-payments-app/blob/develop/terraform/luke-dev.tfvars) | 
| Development - Lav (Domaine) | `dev-lav` | [Terraform Config](https://github.com/meetdomaine/curacao-offsite-payments-app/blob/develop/terraform/lav-dev.tfvars) | 

## AWS Profiles

Set up your AWS profile for the `curacao` account by adding the following to your `~/.aws/credentials`
and `~/.aws/config` files:

```ini
# ~/.aws/credentials
[curacao]
aws_access_key_id = YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY

# ~/.aws/config
[profile curacao]
region = us-west-2
output = json
```

## Deployment Steps

### 1. Initial Setup

#### 1/a. Create Terraform State Bucket

A Terraform backend S3 bucket is crucial for this project to manage and store the Terraform state files. These state
files maintain a record of the infrastructure resources deployed by Terraform and their respective configurations.
Utilizing an S3 bucket as a backend ensures a centralized, secure, and versioned storage solution that enables
collaboration among team members, mitigates the risk of accidental state file loss or corruption, and facilitates easy
rollbacks to previous infrastructure states when necessary.

```bash
make create-bucket
```

#### 1/b. Initialize the Terraform backend by running:

```bash
terraform init
```

#### 1/c. Sync Shopify Certificates

To synchronize the Shopify certificates for mutual TLS (mTLS), run the following command:

```bash
make sync-shopify-certificates
```

This command will ensure that the necessary Shopify certificates are in place for secure communication.

#### Configuration

- `main.tf`: The starting point of the Terraform plan. Set the AWS profile, region, and update the Terraform
  backend with the current state of the project.
- `[staging|production].tfvars`: Set the AWS resource sizes for the respective environment.
- `sg.tf`: Add Security Group rules for the infrastructure.

### 2. Testing Terraform Plans

Test your Terraform plan with the appropriate `.tfvars` file:

```sh
make plan-[staging|production]
```

#### Testing the Terraform Plan for the Development Environments
```sh
make plan-[dev-lav|dev-luke]
```

### 3. Deploying Terraform Infrastructure

Apply the Terraform plan with the appropriate `.tfvars` file:

```sh
make apply-[staging|production]
```

#### Deploying the Terraform Infrastructure for the Development Environments
```sh
make apply-[dev-lav|dev-luke]
```

### 4. Creating Access Keys for the Cloudflare admin app
```sh
make create-access-keys-[staging|production]
```

#### Creating Access Keys for the Cloudflare admin app in the Development Environments
```sh
make create-access-keys-[dev-lav|dev-luke]
```

**NOTE:** Be careful when deploying to avoid accidentally replacing or destroying AWS resources.

## Good to know - Terraform commands

View the available workspaces:

```bash
terraform workspace list
```

Switch to Terraform Workspace:

```sh
terraform workspace select [staging|production]
```

Format the configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

View the output of the service endpoints:

```bash
terraform output
```

## Destroying the Environment

Destroy the environment:

```bash
terraform destroy -var-file=[staging|production].tfvars
```
