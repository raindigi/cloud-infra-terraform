# Cloud infrastructure — Terraform

This repo shows how to use Terraform to create a typical cloud infrastructure on the major cloud providers.

> _See also [cloud-infra-cli](https://github.com/weibeld/cloud-infra-terraform) for creating the same cloud infrastructure with the cloud providers' CLI clients._

## Contents

- **[`aws/`](aws):** Terraform configuration for [Amazon Web Services (AWS)](https://aws.amazon.com/)
- **[`gcp/`](gcp):** Terraform configuration for [Google Cloud Platfrom (GCP)](https://cloud.google.com/)

## Cloud infrastructure

The cloud infrastructure consists of the following generic components:

- A virtual private cloud (VPC) network
- A subnet (with a private IP address range of 10.0.0.0/16)
- Firewall rules that allow the following types of incoming traffic:
    - All traffic from other instances of the example infrastructure
    - HTTP traffic from everywhere
    - SSH traffic from your local machine
- 3 compute instances (running Ubuntu 18.04)

All compute instances get a public IP address and you will be able to connect to them with SSH from your local machine.

_The concrete resources that are created for each cloud provider are listed below._

## Prerequisites

You must have Terraform installed on your system.

For Linux, you can [download the appropriate Terraform binary](https://www.terraform.io/downloads.html) and move it to any directory in your `PATH`.

On macOS, you can install Terraform with:

```bash
brew install terraform
```
