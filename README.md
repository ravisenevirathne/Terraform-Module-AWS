

###########################################################
###########################################################

# **Deployment Process**

1. First setup AWS environments variables relating to the AWS account which provide authentication for terraform to execute 
```
    $ export AWS_ACCESS_KEY_ID= xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
2.  `main.tf` utilizing `ec2.tf` and `key-pair.tf` modules to create the resources on AWS.  execute below terraform commands in following order to create resources
 ```
    terraform init
    terraform plan 
    terraform apply --auto-approve
```
3.  Input parameters
    Given subnet names and Availability zones have been setup as map variable and then used in setting up default subnet name tag

#######setting up required Subnet names and Availability Zones as a map
```
variable "AZs" {
  type = map
  default = {
  subnet-az-2a = "ap-southeast-2a"
  subnet-az-2b = "ap-southeast-2b"
  subnet-az-2c = "ap-southeast-2c"
  }
}
```
#######Add given Names tags to each default subnet on availability zone
```
resource "aws_default_subnet" "updateName" {

  for_each = var.AZs
  availability_zone = each.value
  tags = {
    Name = each.key
  }
}
```
#######Setting up subnet name for each AZ is required as "subnet_name" is used in ec2.tf module to filter data to find the subnet_id

#######Unique names has been passing to each EC2 with the paramter value passing in for_each loop
```
    for_each = var.AZs 
        ami = data.aws_ami.latest-amazon-linux-image.id
        instance_type = "t3.micro"
        name_tag = "EC2-${each.value}" 
        availability_zone = each.value
        subnet_name = each.key
```
4. Outputs
    Instance_IDs, Private and Public keys are setup as outputs
```
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
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
25ytqK2AffTnJZiRLIeQZeEzOSL2iX8wTLkcv4A6gffi1LmNSwLy
-----END RSA PRIVATE KEY-----

EOT
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxpZH8jEFOTxHhMJWBesb53LtnsnFknuB8zJvxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxA0LaKqCt6FJAWs8e7Dzw0UU0MfDVsddj3sjEMf55g+cHXC/j2b8wV2JcatvF5Ug0jHoqCj5GKSK4OiGTv"
```
5. Following AWS resources has been created

![image](https://user-images.githubusercontent.com/85973309/142786100-dbd0fa50-9817-4849-b353-784482412cd8.png)


![image](https://user-images.githubusercontent.com/85973309/142786073-461d6a26-663a-423a-b95e-83080cd898e8.png)


