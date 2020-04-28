# Amazon Web Services (AWS)

![AWS](../assets/aws.png)

## Prerequisites

You need to have a public/private key-pair on your local machine that you will use to connect to the instances with SSH.

You can create a new key-pair with:

```bash
ssh-keygen -f key
```

This creates two files named `key` and `key.pub` in your current working directory:

- `key` is the private key
- `key.pub` is the public key

The public key has to be passed to a variable of the Terraform configuration (see below), and the private key can be used to connect to the instances with SSH after they have been created.

Instead of creating a new key-pair, you can also use an existing key pair on your machine, such as, the default `~/.ssh/id_rsa` (private key) and `~/.ssh/id_rsa.pub` (public key).

## Usage

### Define variables

> You can see all the variables exposed by the Terraform configuration in [`variables.tf`](variables.tf).

Create a `terraform.tfvars` file that defines values for at least the required variables (those without a default value):

```
public_key_file = "<PUBLIC-KEY-FILE>"
localhost_ip = "<IP>"
```

Where:

- `<PUBLIC-KEY-FILE>` is the name of your public key file (e.g. `key.pub`).
- `<IP>` is the public IP address of your local machine. You can find it out with `curl -s checkip.amazonaws.com`.

You can also define values for any of the optional variables (those with a default value) in the `terraform.tfvars` file.

### Create the infrastructure

```bash
terraform apply
```

### Delete the infrastructure

```bash
terraform destroy`
```
## Created infrastructure

The Terraform configuration creates (and deletes) the following AWS resources:

- 1 [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) (1 route table, 1 security group, 1 [network ACL](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html))
- 1 [internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
- 1 [subnet](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
- 1 [route table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
- 2 [security groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- 1 [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- 3 [EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) (3 [EBS volumes](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html), 3 [network interfaces](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html))

## Accessing the infrastructure

At the end of the execution, the `terraform apply` command outputs the names, private IP addresses, and public IP addresses of the created instances.

> You can display this output at any time with `terraform output`.

You can connect to any of these instances with:

```bash
ssh -i <PRIVATE-KEY-FILE> ubuntu@<PUBLIC-IP>
```

Where:

- `<PRIVATE-KEY-FILE>` is the name of your private key file (e.g. `key`)
- `<PUBLIC-IP>` is the public IP address of the instance as shown by `terraform output`

> Note that, by design, SSH connections are only allowed from the IP address that you assigned to the `localhost_ip` variable, that is, from your local machine.
