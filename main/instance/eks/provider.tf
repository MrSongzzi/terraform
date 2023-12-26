

terraform {
  backend "s3" {
    key            = "main/instance/eks/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}
data "terraform_remote_state" "resources" {
  backend = "s3"
  config = {
    bucket  = var.backend_bucket
    key     = "env:/${terraform.workspace}/main/dependency/resources/terraform.tfstate"
    region  = "ap-northeast-2"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
    kubernetes = {
       source  = "hashicorp/kubernetes"
       version = "~> 2.23"

     }
     kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {  
  region = "ap-northeast-2"  
}

#  }
provider "kubernetes" {
  config_path = "~/.kube/config"
  host = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.ca_certificate)
  token = module.eks.token
}

provider "helm" {
  repository_config_path = "${path.module}/.helm/repositories.yaml" 
  repository_cache       = "${path.module}/.helm"
  kubernetes {
    config_path = "~/.kube/config"
    host = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.ca_certificate)
    token = module.eks.token
  }
}

provider "kubectl" {
    host = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.ca_certificate)
    token = module.eks.token
    load_config_file = false
}

