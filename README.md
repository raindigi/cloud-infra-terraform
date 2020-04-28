# Cloud infrastructure — Terraform

This repo shows how to create an example cloud infrastructure on the major cloud providers with Terraform.

> _See also [cloud-infra-cli](https://github.com/weibeld/cloud-infra-terraform) for creating the same cloud infrastructure with the official cloud providers CLI clients._

## Contents

- **[Amazon Web Services (AWS)](aws/README.md):** using the [`aws`](https://www.terraform.io/docs/providers/aws/index.html) Terraform provider to create AWS infrastructure
- **[Google Cloud Platform (GCP)](gcp/README.md):** using the [`google`](https://www.terraform.io/docs/providers/google/index.html) Terraform provider to create GCP infrastructure

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

_The concrete resources that are created for each cloud provider are listed in the corresponding subdirectories._

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
