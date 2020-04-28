# Google Cloud Platform (GCP)

![GCP](../assets/gcp.png)

## Prerequisites

To enable Terraform to access your GCP account, you need to create a [GCP service account](https://cloud.google.com/iam/docs/service-accounts), grant it appropriate permissions, and create a key for it.

Create a service account for Terraform:

```bash
gcloud iam service-accounts create terraform --display-name Terraform
```

Retrieve the email address of the created service account and the ID of the current GCP project (you will use them below):

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

> Note that this file is referenced by the `service_account_key_file` variable in [`variables.tf`](variables.tf).

## Usage

### Define variables

> You can see all the variables exposed by the Terraform configuration in [`variables.tf`](variables.tf).

Create a `terraform.tfvars` file that assigns values to at least the required variables (those with no default value):

```
project = "<GCP-PROJECT-ID>"
localhost_ip = "<IP>"
```

Please replace `<GCP-PROJECT-ID>` with the ID of your current GCP project and `<IP>` with the public IP address of your local machine. You can find out these values as follows:

- GCP project ID: `gcloud config get-value project`
- Local machine IP address: `curl -s checkip.amazonaws.com`

You can also set any of the optional variables (those with a default value) in the `terraform.tfvars` file.

### Create the infrastructure

```bash
terraform apply
```

### Delete the infrastructure

```bash
terraform destroy`
```
## Created infrastructure

The Terraform configuration creates (and deletes) the following GCP resources:

- 1 [VPC network](https://cloud.google.com/vpc/docs/vpc)
- 1 [subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets)
- 3 [firewall rules](https://cloud.google.com/vpc/docs/firewalls)
- 3 [VM instances](https://cloud.google.com/compute/docs/instances)

## Accessing the infrastructure

When the `terraform apply` command completes, it shows an output that lists the names, private IP addresses, and public IP addresses of the created instances.

> You can display this output at any time with `terraform output`.

You can connect to any of the instances with:

```bash
gcloud compute ssh <NAME>
```

Where `<NAME>` is the name of the instance as shown by `terraform output`.

You can also connect to the instances with your native SSH client with:

```bash
ssh -i ~/.ssh/google_compute_engine <PUBLIC-IP>
```

Where `<PUBLIC-IP>` is the public IP address of the instance as shown by `terraform output`.

> Note that, by design, SSH connections are only allowed from the IP address that you assigned to the `localhost_ip` variable, that is, from your local machine.
