# ----------------------------------------------------------------------------------------------------
# --------------------------- VPC with 2 private subnets & 2 public subnets --------------------------
# ----------------------------------------------------------------------------------------------------

# ----------------------------- VPC, Main Network ACL & DHCP Options Set -----------------------------

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name          = var.vpc_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack
  }

  tags_all = {
    Name          = var.vpc_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack
  }
}

# DHCP Options Set & Association
resource "aws_vpc_dhcp_options" "dhcp_options_set" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS",]

  tags = {
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack
  }
}

resource "aws_vpc_dhcp_options_association" "association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options_set.id
}

# ----------------------------------------------------------------------------------------------------
# -------------------------- Main Public Route Table & Internet Gateway ------------------------------

# Main (Public) Route Table associated with VPC.
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = var.rt_public_route1_cidr_block
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = aws_internet_gateway.gw.id
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name          = var.rt_public_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

# Internet Gatewat
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name          = var.gw_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

# ----------------------------------------------------------------------------------------------------
# ------------------------------ Private Route Table & NAT Gateway  ----------------------------------

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  route = [
    {
      carrier_gateway_id         = var.rt_private_route1_carrier_gateway_id
      cidr_block                 = var.rt_private_route1_cidr_block
      destination_prefix_list_id = var.rt_private_route1_destination_prefix_list_id
      egress_only_gateway_id     = var.rt_private_route1_egress_only_gateway_id
      gateway_id                 = var.rt_private_route1_gateway_id
      instance_id                = var.rt_private_route1_instance_id
      ipv6_cidr_block            = var.rt_private_route1_ipv6_cidr_block
      local_gateway_id           = var.rt_private_route1_local_gateway_id
      nat_gateway_id             = aws_nat_gateway.nat_gateway.id
      network_interface_id       = var.rt_private_route1_network_interface_id
      transit_gateway_id         = var.rt_private_route1_transit_gateway_id
      vpc_endpoint_id            = var.rt_private_route1_vpc_endpoint_id
      vpc_peering_connection_id  = var.rt_private_route1_vpc_peering_connection_id
    },
    {
    carrier_gateway_id         = var.rt_private_route2_carrier_gateway_id
    cidr_block                 = var.rt_private_route2_cidr_block
    destination_prefix_list_id = var.rt_private_route2_destination_prefix_list_id
    egress_only_gateway_id     = var.rt_private_route2_egress_only_gateway_id
    gateway_id                 = var.rt_private_route2_gateway_id
    instance_id                = var.rt_private_route2_instance_id
    ipv6_cidr_block            = var.rt_private_route2_ipv6_cidr_block
    local_gateway_id           = var.rt_private_route2_local_gateway_id
    nat_gateway_id             = var.rt_private_route2_nat_gateway_id
    network_interface_id       = var.rt_private_route2_network_interface_id
    transit_gateway_id         = var.rt_private_route2_transit_gateway_id
    vpc_endpoint_id            = var.rt_private_route2_vpc_endpoint_id
    vpc_peering_connection_id  = aws_vpc_peering_connection.interconection.id
    }
  ]

  tags = {
    Name = var.rt_private_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack
  }
}

# NAT Gateway associated with Private Route Table
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.subnet_public_1a.id
  allocation_id = aws_eip.eip.id

  tags       = {
    Name = var.nat_gateway_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
  depends_on = [aws_internet_gateway.gw]
}

# Elastic IP associated with NAT Gateway
resource "aws_eip" "eip" {
  vpc = true
}


# NAT Gateway associated with Private Route Table
resource "aws_nat_gateway" "nat_gateways" {
  subnet_id     = aws_subnet.subnet_public_1b.id
  allocation_id = aws_eip.eips.id

  tags       = {
    Name = var.nat_gateway_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
  depends_on = [aws_internet_gateway.gw]
}

# # Elastic IP associated with NAT Gateway
resource "aws_eip" "eips" {
  vpc = true
}

# ----------------------------------------------------------------------------------------------------
# ---------------------------------------- 2 Public & 2 Private Subnets ------------------------------

resource "aws_subnet" "subnet_public_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_public_1a_cidr_block
  availability_zone = var.availability_zone_a

  tags = {
    Name = var.subnet_public_1a_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }

  tags_all = {
    Name = var.subnet_public_1a_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

resource "aws_subnet" "subnet_public_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_public_1b_cidr_block
  availability_zone = var.availability_zone_b
  tags              = {
    Name = var.subnet_public_1b_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }

  tags_all = {
    Name = var.subnet_public_1b_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_private_1a_cidr_block
  availability_zone = var.availability_zone_a

  tags = {
    Name = var.subnet_private_1a_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }

  tags_all = {
    Name = var.subnet_private_1a_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

resource "aws_subnet" "subnet_private_1b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_private_1b_cidr_block
  availability_zone = var.availability_zone_b

  tags = {
    Name = var.subnet_private_1b_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }

  tags_all = {
    Name = var.subnet_private_1b_name
    "Cost Center" = var.cost_center
    Creator       = var.creator
    Stack         = var.stack    
  }
}

# ----------------------------------------------------------------------------------------------------
# ---------------------------------------- 2 Association a and b ------ ------------------------------

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.subnet_private_1a.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.subnet_private_1b.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.subnet_public_1a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.subnet_public_1b.id
  route_table_id = aws_route_table.rt_public.id
}

##-------------------------------- RESOURCES DEFAULT ACL AND SG -------------------------------------

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.id
  tags = var.tags_all
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags = var.tags_all
}

# ----------------------------------------------------------------------------------------------------
# ---------------------------------------- logs in cloudwatch--- -------------------------------------

resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.vpc.arn
  log_destination = aws_cloudwatch_log_group.vpc.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "vpc" {
  name = var.log_group
  retention_in_days = 30
  tags = var.tags_all
  }

resource "aws_iam_role" "vpc" {
  name = "role-${var.vpc_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc" {
  name = "policy-${var.vpc_name}"
  role = aws_iam_role.vpc.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


## ----------------------  VPC ENDPOINT EC2 ----------------------------------

resource "aws_security_group" "sg-principal" {
  name        = "${var.vpc_name}-sg-principal"
  description = "Principal security group for ${var.vpc_name}"
  vpc_id      = aws_vpc.vpc.id
    egress                 = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
                ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
            },
        ]
    ingress                = [
        {
            cidr_blocks      = [
                "10.17.0.0/16",
                ]
            description      = "All traffic from VPC Tigo"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
            },
        {
            cidr_blocks      = [
                "${var.vpc_cidr_block}",
                ]
            description      = "All traffic from ${var.vpc_name}"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
            },
        ]
  tags = var.tags_all
}

resource "aws_vpc_endpoint" "ec2" {
    private_dns_enabled   = true
    route_table_ids       = []
    security_group_ids    = [
        aws_security_group.sg-principal.id,
        ]
    service_name          = "com.amazonaws.us-east-1.ec2"
    subnet_ids            = [
        aws_subnet.subnet_private_1a.id,
        aws_subnet.subnet_private_1b.id,
        ]
      tags = {
        Name = "${var.vpc_name}-ec2"
        "Cost Center" = var.cost_center
        Creator       = var.creator
        Stack         = var.stack    
  }
    vpc_endpoint_type     = "Interface"
    vpc_id                = aws_vpc.vpc.id
    policy                = jsonencode(
            {
            Statement = [
                {
                    Action    = "*"
                    Effect    = "Allow"
                    Principal = "*"
                    Resource  = "*"
                    },
                ]
            }
        )
    timeouts {}
    }

## ---------------------------------------  VPC ENDPOINT S3 ------------------------------------------

resource "aws_vpc_endpoint" "s3" {
    private_dns_enabled   = false
    route_table_ids       = [
      aws_route_table.rt_private.id,
    ]
    service_name          = "com.amazonaws.us-east-1.s3"
      tags = {
        Name = "${var.vpc_name}-s3"
        "Cost Center" = var.cost_center
        Creator       = var.creator
        Stack         = var.stack    
  }
    vpc_endpoint_type     = "Gateway"
    vpc_id                = aws_vpc.vpc.id
    policy                = jsonencode(
            {
              Version = "2008-10-17",
              Statement = [
                {
                    Action    = "*"
                    Effect    = "Allow"
                    Principal = "*"
                    Resource  = "*"
                    },
                ]
            }
        )
    timeouts {}
    }

### --------------------- PEERING VPC TIGO WITH NEW VPC -----------------------------------

resource "aws_vpc_peering_connection" "interconection" {
  # peer_owner_id = var.peer_owner_id
  peer_vpc_id   = "vpc-"
  vpc_id        = aws_vpc.vpc.id
  auto_accept   = true
  
  accepter {
    allow_remote_vpc_dns_resolution = false
  }

  requester {
    allow_remote_vpc_dns_resolution = false
  }
        tags = {
        Name = "${var.vpc_name}-with-vpc-tigo"
        "Cost Center" = var.cost_center
        Creator       = var.creator
        Stack         = var.stack    
  }
}