# Cloud infrastructure — Terraform

This repo shows how to create an example cloud infrastructure on the major cloud providers with Terraform.

> _See also [cloud-infra-cli](https://github.com/weibeld/cloud-infra-terraform) for creating the same cloud infrastructure with the official cloud providers CLI clients._

## Contents

- **[Amazon Web Services (AWS)](#amazon-web-services-aws):** using the [`aws`](https://www.terraform.io/docs/providers/aws/index.html) Terraform provider to create AWS infrastructure
- **[Google Cloud Platform (GCP)](#google-cloud-platform-gcp):** using the [`google`](https://www.terraform.io/docs/providers/google/index.html) Terraform provider to create GCP infrastructure

## Example cloud infrastructure

The cloud infrastructure consists of the following generic components:

- A virtual private cloud (VPC) network
- A subnet with a private IP address range of 10.0.0.0/16
- Firewall rules that allow the following types of traffic:
    - All incoming traffic from other instances of the example infrastructure
    - Incoming HTTP traffic from everywhere
    - Incmoing SSH traffic from your local machine
    - All outgoing traffic to everywhere
- 3 compute instances running Ubuntu 18.04

All compute instances get a public IP address and you will be able to connect to them with SSH from your local machine.

_The detailed infrastructure for each cloud provider is listed below._

## General prerequisites

### Terraform

On macOS, you can install Terraform with:

```bash
brew install terraform
```

On Linux, you can [download the appropriate Terraform binary](https://www.terraform.io/downloads.html) and move it to any directory in your `PATH`.

### Cloud provider CLI clients

You should have the cloud provider CLI clients installed and configured on your system:

- [`aws`](https://aws.amazon.com/cli/) for AWS ([installation instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html))
- [`gcloud`](https://cloud.google.com/sdk/gcloud) for GCP ([installation instructions](https://cloud.google.com/sdk/gcloud#downloading_the_gcloud_command-line_tool))

## Amazon Web Services (AWS)

![AWS](assets/aws.png)


## Google Cloud Platform (GCP)

![GCP](assets/gcp.png)

### Prerequisites

To enable Terraform to access your GCP account, you need to create a [GCP service account](https://cloud.google.com/iam/docs/service-accounts), grant it appropriate permissions, and create a key for it.

Create a service account for Terraform:

```bash
gcloud iam service-accounts create terraform --display-name Terraform
```

Retrieve the email address of the created service account as well as the ID of the current GCP project (you will use them below):

```bash
service_account=$(gcloud iam service-accounts list --filter 'displayName:Terraform' --format 'value(email)')
project_id=$(gcloud config list --format 'value(core.project)')
```

Add the [Editor](https://console.cloud.google.com/iam-admin/roles/details/roles%3Ceditor) role to the Terraform service account:

```bash
gcloud projects add-iam-policy-binding "$project_id" --member serviceAccount:"$service_account" --role roles/editor
```

Create a [service account key](https://cloud.google.com/iam/docs/reference/rest/v1/projects.serviceAccounts.keys) for the Terraform service account and save it on your local machine:

```bash
gcloud iam service-accounts keys create key.json --iam-account "$service_account"
```

The above command creates a file named `key.json` and saves it in your current working directory.

> Please make sure that the `key.json` file is located in the `gcp/` directory.



