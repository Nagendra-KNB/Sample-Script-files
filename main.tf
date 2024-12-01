
# Generate a random suffix for unique resource names
resource "random_id" "suffix" {
  byte_length = 4
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr  # Define the CIDR block for the VPC

  tags = {
    Name = "pixar-vpc"       # Tag the VPC for easier identification
  }
}

# Create public subnets in different availability zones
resource "aws_subnet" "subnet1" {
  vpc_id                   = aws_vpc.main.id       # Associate the subnet with the VPC
  cidr_block               = var.subnet1_cidr      # CIDR block for the subnet
  availability_zone        = "ap-south-1a"         # Specify the availability zone
  map_public_ip_on_launch  = true                  # Automatically assign public IPs to instances

  tags = {
    Name = "pixar-vpc-Subnet1"                     # Tag the subnet for identification
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.subnet2_cidr
  availability_zone        = "ap-south-1b"  # Change as needed
  map_public_ip_on_launch  = true

  tags = {
    Name = "pixar-vpc-Subnet2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.subnet3_cidr
  availability_zone        = "ap-south-1c"  # Change as needed
  map_public_ip_on_launch  = true

  tags = {
    Name = "pixar-vpc-Subnet3"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id                    # Attach the Internet Gateway to the VPC

  tags = {
    Name = "pixar-vpc-IGW"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id                   # Associate the route table with the VPC

  route {
    cidr_block     = "0.0.0.0/0"                          # Route for all outbound traffic
    gateway_id     = aws_internet_gateway.igw.id          # Route traffic through the Internet Gateway
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate the route table with all public subnets
resource "aws_route_table_association" "subnet_association1" {
  subnet_id      = aws_subnet.subnet1.id                # Associate with subnet1
  route_table_id = aws_route_table.public_rt.id         # Use the public route table
}

resource "aws_route_table_association" "subnet_association2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_association3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.public_rt.id
}

# Custom security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "pixar-SG-1-${random_id.suffix.hex}" # Unique name using random ID
  vpc_id      = aws_vpc.main.id                      # Associate with the VPC

 # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                       # Allow access from anywhere
  }

 # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pixar-Security-group"
  }
}

# EC2 Instance
resource "aws_instance" "instance" {
  ami                   	 = var.ami_id           # Specify the AMI ID
  instance_type         	 = var.instance_type    # Instance type (e.g., t2.micro)
 key_name               	 = var.key_pair_name    # Key pair for SSH access
  vpc_security_group_ids	 = [aws_security_group.instance_sg.id]
  subnet_id             	 = aws_subnet.subnet1.id  # Choose subnet1, subnet2 or subnet3
  associate_public_ip_address	 = var.associate_public_ip
  tags = {
    Name = var.instance_name
  }
# Root block device configuration
root_block_device {
    volume_size = var.volume_size    # Define the volume size
    volume_type = "gp3"             # General purpose SSD (optional, but common)
  }

# File provisioner to copy Ansible playbook and scripts
  provisioner "file" {
    source      = "./ansible-script"             # Local path to your Ansible scripts to install all server configuration
    destination = "/home/ubuntu/ansible-script"  # Remote directory where files will be copied
  }

  provisioner "file" {
    source      = "./pixer-ai-python"             # Local path to your Ansible scripts to deploy python scripts over server
    destination = "/home/ubuntu/pixer-ai-python"  # Remote directory where files will be copied
  }
  provisioner "file" {
    source	= "./ansible-script"
    destination = "/home/ubuntu/ansible-script"
  }
  # Provisioner to install Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install software-properties-common -y",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y"
    #  "cd /home/ubuntu/ansible-script && ansible-playbook ansible-playbook.yml",
    #  "cd /home/ubuntu/pixer-ai-python && ansible-playbook application-deploy.yml --extra-vars='@secrete.yml'",
    #  "cd /home/ubuntu/ansible-script && sudo ansible-playbook postgres-playbook.yml"
    ]
  }


  # SSH connection block
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/server16/pem-keys/terraform-test.pem")       ##ATTENTION##  modify this according to your pem-key paths 
    host        = self.public_ip
  }


}
# Create an Elastic IP
#resource "aws_eip" "instance_eip" {
#  domain = "vpc"
#
#  tags = {
#    Name = "pixar-instance-eip"
#  }
#}

# Associate the Elastic IP with the EC2 instance
#resource "aws_eip_association" "instance_eip_assoc" {
#  instance_id = aws_instance.instance.id
#  allocation_id = aws_eip.instance_eip.id
#}

# Output the public IP of the instance (Elastic IP)
output "instance_public_ip" {
  value = aws_eip.instance_eip.public_ip
}

