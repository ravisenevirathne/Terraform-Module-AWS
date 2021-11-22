//setting  "ap-southeast-2" as the region
provider "aws" {
    region = "ap-southeast-2"
}


//setting up required Subnet names and Availability Zones as a map
variable "AZs" {
  type = map
  default = {
  subnet-az-2a = "ap-southeast-2a"
  subnet-az-2b = "ap-southeast-2b"
  subnet-az-2c = "ap-southeast-2c"
  }
}

//Add given Names tags to each default subnet on availability zone
resource "aws_default_subnet" "updateName" {

  for_each = var.AZs
  availability_zone = each.value
  tags = {
    Name = each.key
  }
}

//returning the latest Amazon linux image
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

//creating "Contino" keypair by using "key-pair" module
module "key-pairmoudule" {
  source = "./modules/key-pair"

  key_name = "Contino"
}

//creating 3 x EC2 instances using "ec2" module with utilizing for_each loop
module "ec2_Instances" {
  source  = "./modules/ec2"

  for_each = var.AZs 
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t3.micro"
  name_tag = "EC2-${each.value}"   //setting up unique name tag based on availability zone name
  availability_zone = each.value
  subnet_name = each.key

  //setting up Names tags to each default subnet on availability zone before executing this module
  depends_on = [
    aws_default_subnet.updateName
  ]
}


//output of Instance ID
output "Instance_ID" {
  value = module.ec2_Instances[*]
}

//output of public_key
output "public_key" {
  value = module.key-pairmoudule.public_key
}

//output of private_key
output "private_key" {
  value =  nonsensitive(module.key-pairmoudule.private_key)
  //sensitive = true
}
