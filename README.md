# Scenario:

The Application team requires 2 EC2 instances to be provisioned. They have already written a module for EC2 instances.
Your job is to reuse the `ec2` and `key-pair` modules to provision 3 instances with the following properties passed in as input parameters:

- Instance Type: `t3.micro`
- Tags: Add a `Name` tag that is unique for each instance.

It has also been decided that each EC2 instance needs to be provisioned in the following Availability Zones and Subnets.

| Subnet | Availability Zone |
|--------|-------------------|
| subnet-az-2a | ap-southeast-2a |
| subnet-az-2b | ap-southeast-2b |
| subnet-az-2c | ap-southeast-2c |

<br>

Also output the following values:

1. A list of all Instance IDs.
2. The Public and Private key of the Key Pair as a Map

<br>

## Deliverables:

1. Write a clear and understandable README.md file which details deployment process, any input parameters and any outputs.
2. A `private` repository with the code.
3. A blueprint Terraform file that uses the modules to provision the resources.

<br>

## Extras:

You can either code or explain how the following could be accomplished:

1. CI/CD pipeline for deployment to a Terraform Cloud workspace.
2. Any tests to check for success or failure of the pipeline.

==========================================================================================================================================================
Deployment Process

1. First setup AWS environments variables relating to the AWS account which provide authentication for terraform to execute 
    $ export AWS_ACCESS_KEY_ID= xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx

2  main.tf utilizing ec2.tf and key-pair.tf modules to create the resources on AWS.  execute below terraform commands in following order to create resources
    terraform init
    terraform plan 
    terraform apply --auto-approve

3  Input parameters
    Given subnet names and Availability zones have been setup as map variable and then used in setting up default subnet name tag

#######setting up required Subnet names and Availability Zones as a map
variable "AZs" {
  type = map
  default = {
  subnet-az-2a = "ap-southeast-2a"
  subnet-az-2b = "ap-southeast-2b"
  subnet-az-2c = "ap-southeast-2c"
  }
}

#######Add given Names tags to each default subnet on availability zone
resource "aws_default_subnet" "updateName" {

  for_each = var.AZs
  availability_zone = each.value
  tags = {
    Name = each.key
  }
}

    **Setting up subnet name for each AZ is required as "subnet_name" is used in ec2.tf module to filter data to find the subnet_id

    **Unique names has been passing to each EC2 with the paramter value passing in for_each loop
    for_each = var.AZs 
        ami = data.aws_ami.latest-amazon-linux-image.id
        instance_type = "t3.micro"
        name_tag = "EC2-${each.value}" 
        availability_zone = each.value
        subnet_name = each.key

4. Outputs
    Instance_IDs, Private and Public keys are setup as outputs

    Instance_ID = [
  {
    "subnet-az-2a" = {
      "ec2-instance-id" = "i-0fb94d00540f60d55"
      "ec2-instance-name" = "EC2-ap-southeast-2a"
    }
    "subnet-az-2b" = {
      "ec2-instance-id" = "i-075c26474a8437394"
      "ec2-instance-name" = "EC2-ap-southeast-2b"
    }
    "subnet-az-2c" = {
      "ec2-instance-id" = "i-0a043ffb1738ca649"
      "ec2-instance-name" = "EC2-ap-southeast-2c"
    }
  },
]
private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAxC4pZio6tnkpAb+9SsHDBOK0n1e6YzlDNL36alFCrsdC2G7A
Rs49gZplp1BIC36ktHRZR8rphqmgUKEJ6E88N/+7EIfEBu66qNtSXeP+6FcQ/Q8x
ma/C6XqZc0dQ1HxtNQu22j9sJcVkbls57F8awy4WafO6anaWR/IxBTk8R4TCVgXr
G+dy7Z7JxZJ7gfMyb18o53N/Kflg5IB/u0eMrAa/Z+xt5fu/OeeQDZACjtJZVdPP
HGt7TfJJriWQSJM8tOPdgNC2iqgrehSQFrPHuw88NFFNDHw1bHXY97IxDH+eYPnB
1wv49m/MFdiXGrbxeVINIx6Kgo+RikiuDohk7wIDAQABAoIBAHaOAvy3pnWhcLOa
4NTtlWI9crQcuwm9kCyuZkebxfWDe5T6EP55IlhRKv9al79CkFxxN4cYS9nSZoxz
VV5ri9O3mp+ZvFAIMwtaR0NwRhq4iw6zAOGEgwC/0z4EKgfPDdwRsTXhQATvbgr2
3GFI9A5hqq/q14wBED54UUF73j7FH++5BsQw4W/bh8Aoo3hJgCugsoyT6hChDAIP
YB+NL9rlPdPqR+pwI8JnFTucB3T90LJ8KdkV1RCQBRjthKK68VoNO2QhSVQYiS+T
IKyrSu3mj+LYMus369PwqwgGbs4Q76obnpVcrV8EFanrnngaNvxsPBsuSEArFvmI
fiBVqrECgYEA6Ox6D3cMXNctkbxEXEqa/7pzNtfSnkDQ1gYlOLFPlc9wf3WXtJxq
svdd3SQQntzXqNvtV/nA67pcfwrGcv+YttKDpmnBzSjIBiojzz8EaeEk44xpo7H2
31XxxsTz5Re05WQN4LQSl8F68rF8tDb5PYDrrw0k1DHC6mRL2vSw6+kCgYEA153H
4MFlWZqkBvIQr4WM8/Etp9xn8owL0c1Nb++iCbj7x2of2coRMtHSmAZJK58SH20G
c+U6x+ZXS4Os5yfFKd1/kyiVcmTHWULoRxC1issBs5YfVF70wMY9Bv3uTFdAKMKf
Te+ZEgOVL8L+eZbS0DToB05lTMIj9yWuR0HQuxcCgYA+51ZThOAW1pnc6M5BaniP
pafl4MVlrbV4h3JX7DLFD5+fHH/a6/840+tKhKnkbVnkpXhksPNz9gFy4dMUTYjN
nu6k65zGLkROveSr3KXxfjc7KLmC1tYIHKrN9nSzowJcjPfefmMjDsKIdnxqIwqO
nJmJze/rSoEMUgfWWwzIuQKBgDR2VY3gQJK+x65Q87JhYlxwkFVJkZk4bh/MPk1A
F0MaWVi5/6n0Op8M4prO3LraZ4Rx+KH2YokFCLR9A3LzAEwhcssRkttUnhSf7Pht
nl546p8RpenXeOH22h57ZqH4kMnaIPzLkYkKiiAm59gZ1I2IcfRlJMy6aBnYd0Er
SGhdAoGBALTxfSMBXNOSUhj26oCX0+lPUQD3BEAWD48zBEd0mTDnOtE58mkKEl6f
H7C71H67mdmVUzqWX7Dtl/2wDXye3Xzhhpyzmoc2SRQXrVPxBUqymP3//bjZgw4F
25ytqK2AffTnJZiRLIeQZeEzOSL2iX8wTLkcv4A6gffi1LmNSwLy
-----END RSA PRIVATE KEY-----

EOT
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDELilmKjq2eSkBv71KwcME4rSfV7pjOUM0vfpqUUKux0LYbsBGzj2BmmWnUEgLfqS0dFlHyumGqaBQoQnoTzw3/7sQh8QG7rqo21Jd4/7oVxD9DzGZr8LpeplzR1DUfG01C7baP2wlxWRuWznsXxrDLhZp87pqdpZH8jEFOTxHhMJWBesb53LtnsnFknuB8zJvXyjnc38p+WDkgH+7R4ysBr9n7G3l+78555ANkAKO0llV088ca3tN8kmuJZBIkzy0492A0LaKqCt6FJAWs8e7Dzw0UU0MfDVsddj3sjEMf55g+cHXC/j2b8wV2JcatvF5Ug0jHoqCj5GKSK4OiGTv"

5. Following AWS resources has been created


