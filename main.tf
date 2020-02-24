# Specify Provider Details
provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

# Create VPC with IpV4 Class A CIDR block of 256 IPs
resource "aws_vpc" "terraform_ecs_fargate_vpc" {
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

# Create an internet gateway (virtual router that connects a VPC to the internet)
resource "aws_internet_gateway" "terraform_ecs_fargate_vpc_igt" {
  vpc_id = aws_vpc.terraform_ecs_fargate_vpc.id
}

################################ Availability Zone 1  ###############################

# Create a Public Route table associated with AZ1 and allow IpV4 traffic on Internet Gateway
resource "aws_route_table" "terraform_ecs_fargate_vpc_az1_public_rt" {
  vpc_id = aws_vpc.terraform_ecs_fargate_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ecs_fargate_vpc_igt.id
  }
}

# Create a Private Route table for AZ1
resource "aws_route_table" "terraform_ecs_fargate_vpc_az1_private_rt" {
  vpc_id = aws_vpc.terraform_ecs_fargate_vpc.id
}

################################ Public Subnet Starts ###############################
# Create a public subnet , ensure map_public_ip_on_launch is set to true
resource "aws_subnet" "terraform_ecs_fargate_vpc_az1_public_sn" {
  vpc_id                  = aws_vpc.terraform_ecs_fargate_vpc.id
  cidr_block              = "10.0.0.0/26"
  availability_zone_id    = "use2-az1"
  map_public_ip_on_launch = true
}

# Associate subnet with a internet gateway route
resource "aws_route_table_association" "terraform_ecs_fargate_vpc_az1_public_sn_route" {
  subnet_id      = aws_subnet.terraform_ecs_fargate_vpc_az1_public_sn.id
  route_table_id = aws_route_table.terraform_ecs_fargate_vpc_az1_public_rt.id
}

# Generate an Elastic IP
resource "aws_eip" "terraform_ecs_fargate_vpc_az1_public_sn_ng_elastic_ip" {
}

# Create a Network Address Translation (NAT) Gateway on Public Subnet
# Associate to Public Subnet & an Elastic IP Address
resource "aws_nat_gateway" "terraform_ecs_fargate_vpc_az1_public_sn_ng" {
  allocation_id = aws_eip.terraform_ecs_fargate_vpc_az1_public_sn_ng_elastic_ip.id
  subnet_id     = aws_subnet.terraform_ecs_fargate_vpc_az1_public_sn.id
}
################################ Public Subnet Ends ###############################

################################ Private Subnet Starts ###############################
# Create a private subnet
resource "aws_subnet" "terraform_ecs_fargate_vpc_az1_private_sn" {
  vpc_id               = aws_vpc.terraform_ecs_fargate_vpc.id
  cidr_block           = "10.0.0.64/26"
  availability_zone_id = "use2-az1"
}

# Add a Route in Private Route Table to allow IpV4 traffic using route to NAT Gateway 
resource "aws_route" "terraform_ecs_fargate_vpc_az1_private_sn_internet_access" {
  route_table_id         = aws_route_table.terraform_ecs_fargate_vpc_az1_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.terraform_ecs_fargate_vpc_az1_public_sn_ng.id
}

# Associate subnet with a internet gateway route
resource "aws_route_table_association" "terraform_ecs_fargate_vpc_az1_private_sn_route" {
  subnet_id      = aws_subnet.terraform_ecs_fargate_vpc_az1_private_sn.id
  route_table_id = aws_route_table.terraform_ecs_fargate_vpc_az1_private_rt.id
}

################################ Private Subnet Ends ###############################
################################ Availability Zone 1  Ends ###############################

################################ Availability Zone 2  ###############################
# Create a Public Route table associated with AZ2 and allow IpV4 traffic on Internet Gateway
resource "aws_route_table" "terraform_ecs_fargate_vpc_az2_public_rt" {
  vpc_id = aws_vpc.terraform_ecs_fargate_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_ecs_fargate_vpc_igt.id
  }
}

# Create a Private Route table for AZ2
resource "aws_route_table" "terraform_ecs_fargate_vpc_az2_private_rt" {
  vpc_id = aws_vpc.terraform_ecs_fargate_vpc.id
}

################################ Public Subnet Starts ###############################
# Create a public subnet , ensure map_public_ip_on_launch is set to true
resource "aws_subnet" "terraform_ecs_fargate_vpc_az2_public_sn" {
  vpc_id                  = aws_vpc.terraform_ecs_fargate_vpc.id
  cidr_block              = "10.0.0.128/26"
  availability_zone_id    = "use2-az2"
  map_public_ip_on_launch = true
}

# Associate subnet with a internet gateway route
resource "aws_route_table_association" "terraform_ecs_fargate_vpc_az2_public_sn_route" {
  subnet_id      = aws_subnet.terraform_ecs_fargate_vpc_az2_public_sn.id
  route_table_id = aws_route_table.terraform_ecs_fargate_vpc_az2_public_rt.id
}

# Generate an Elastic IP
resource "aws_eip" "terraform_ecs_fargate_vpc_az2_public_sn_ng_elastic_ip" {
}

# Create a Network Address Translation (NAT) Gateway on Public Subnet
# Associate to Public Subnet & an Elastic IP Address
resource "aws_nat_gateway" "terraform_ecs_fargate_vpc_az2_public_sn_ng" {
  allocation_id = aws_eip.terraform_ecs_fargate_vpc_az2_public_sn_ng_elastic_ip.id
  subnet_id     = aws_subnet.terraform_ecs_fargate_vpc_az2_public_sn.id
}
################################ Public Subnet Ends ###############################

################################ Private Subnet Starts ###############################
# Create a private subnet
resource "aws_subnet" "terraform_ecs_fargate_vpc_az2_private_sn" {
  vpc_id               = aws_vpc.terraform_ecs_fargate_vpc.id
  cidr_block           = "10.0.0.192/26"
  availability_zone_id = "use2-az2"
}

# Add a Route in Private Route Table to allow IpV4 traffic using route to NAT Gateway 
resource "aws_route" "terraform_ecs_fargate_vpc_az2_private_sn_internet_access" {
  route_table_id         = aws_route_table.terraform_ecs_fargate_vpc_az2_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.terraform_ecs_fargate_vpc_az2_public_sn_ng.id
}

# Associate subnet with a internet gateway route
resource "aws_route_table_association" "terraform_ecs_fargate_vpc_az2_private_sn_route" {
  subnet_id      = aws_subnet.terraform_ecs_fargate_vpc_az2_private_sn.id
  route_table_id = aws_route_table.terraform_ecs_fargate_vpc_az2_private_rt.id
}

################################ Private Subnet Ends ###############################
################################ Availability Zone 2  Ends ###############################
# Create a security group to allow web traffic to/from instances running on private / public subnets in our custom VPC
resource "aws_security_group" "terraform_ecs_fargate_vpc_webserver_sg" {
  name        = "terraform_ecs_fargate_vpc_webserver_sg"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.terraform_ecs_fargate_vpc.id

  # SSH 
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP 
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application Load Balancer
resource "aws_lb" "terraform-ecs-alb" {
  name               = "terraform-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_ecs_fargate_vpc_webserver_sg.id]
  subnets            = [aws_subnet.terraform_ecs_fargate_vpc_az1_public_sn.id, aws_subnet.terraform_ecs_fargate_vpc_az2_public_sn.id]
}

# Create Listener for Application Load Balancer 
resource "aws_lb_listener" "terraform-ecs-alb-http-lstn" {
  load_balancer_arn = aws_lb.terraform-ecs-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform-ecs-alb-tg.arn
  }
}

# Create target group to forward http request
resource "aws_lb_target_group" "terraform-ecs-alb-tg" {
  name        = "terraform-ecs-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terraform_ecs_fargate_vpc.id
}

################################ Create Fargate ECS Cluster ###############################
# Create ECS cluster(regional service) is a logical grouping of tasks or services

resource "aws_ecs_cluster" "terraform_ecs_fargate_vpc_cluster" {
  name = "terraform_ecs_fargate_vpc_cluster"
}


resource "aws_ecs_task_definition" "terraform_ecs_fargate_vpc_service_td" {
  family                   = "terraform_ecs_fargate_vpc_service"
  container_definitions    = <<DEFINITION
						  [
							  {
								"name": "sample-app",
								"image": "httpd:2.4",
								"cpu": 256,
								"memory": 512,
								"essential": true,
								"portMappings": [
								  {
									"containerPort": 80,
									"hostPort": 80
								  }
								]
							  }
						 ]
						 DEFINITION							  
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "terraform_ecs_fargate_vpc_service_app" {
  name                               = "terraform_ecs_fargate_vpc_service_app"
  cluster                            = aws_ecs_cluster.terraform_ecs_fargate_vpc_cluster.id
  task_definition                    = aws_ecs_task_definition.terraform_ecs_fargate_vpc_service_td.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100
  launch_type                        = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.terraform_ecs_fargate_vpc_az1_private_sn.id, aws_subnet.terraform_ecs_fargate_vpc_az2_private_sn.id]
    security_groups  = [aws_security_group.terraform_ecs_fargate_vpc_webserver_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.terraform-ecs-alb-tg.arn
    container_name   = "sample-app"
    container_port   = 80
  }
  depends_on = [aws_lb_target_group.terraform-ecs-alb-tg, aws_lb_listener.terraform-ecs-alb-http-lstn, aws_lb.terraform-ecs-alb]
}