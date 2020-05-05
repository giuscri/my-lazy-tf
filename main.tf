terraform {
  backend "s3" {
    bucket = "barbie-dreams"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "eu-central-1a" {
  availability_zone = "eu-central-1a"
}

resource "aws_default_subnet" "eu-central-1b" {
  availability_zone = "eu-central-1b"
}

data "aws_eks_cluster" "cluster" {
  name = module.frazelle-beautiful-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.frazelle-beautiful-cluster.cluster_id
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
  load_config_file = false
  version = "~> 1.9"
}

module "frazelle-beautiful-cluster" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = "frazelle-beautiful-cluster"
  vpc_id = aws_default_vpc.default.id
  subnets = [aws_default_subnet.eu-central-1a.id, aws_default_subnet.eu-central-1b.id]
  config_output_path = pathexpand("~/.kube/config")

  worker_groups = [
    {
      instance_type = "t2.small"
    },
    {
      instance_type = "t2.small"
    },
    {
      instance_type = "t2.small"
    }
  ]
}
