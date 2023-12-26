
locals {  
  kube_version = "1.27"
  desired_size = 1
  min_size = 1
  max_size = 10
  LT_version = "$Latest"
  root_volumes_size = 20
  cluster_name = "cluster"
  node_group_name = "group"
  node_name = "node"
  capacity_type = "ON_DEMAND"

  custom_tag = merge(var.resource_tag, { 
    "k8s.io/cluster-autoscaler/enabled" = ""
    "k8s.io/cluster-autoscaler/${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}" = ""
   })
}

module "eks" {
  source             = "../../../modules/compute/eks"
  private_subnets = data.terraform_remote_state.resources.outputs.priv_subnets
  security_group_id = data.terraform_remote_state.resources.outputs.security_group_id_all
  eks_inst_type = var.eks_inst_type  
  node_role_arn = data.terraform_remote_state.resources.outputs.node_role_arn
  cluster_role_arn = data.terraform_remote_state.resources.outputs.cluster_role_arn
  vpc_id = data.terraform_remote_state.resources.outputs.vpc_id

  kube_version = local.kube_version
  desired_size = local.desired_size
  min_size = local.min_size
  max_size = local.max_size
  LT_version = local.LT_version
  root_volumes_size = local.root_volumes_size
  key_name = var.default_Key
  capacity_type = local.capacity_type

  cluster_name = local.cluster_name
  node_group_name = local.node_group_name
  node_name = local.node_name
  
  prefix_name = var.prefix_name.Owner
  tags = local.custom_tag       
}



module "keyoutput" {
  source = "../../../modules/ETC/output_file"
  value = templatefile("${var.user_templats_path}/eks_readme.tpl", { value = "${var.prefix_name.Owner}-${terraform.workspace}-${local.cluster_name}" })
  tpl_path = "../../common/user_templats/eks_readme.tpl"
  out_path = "${path.module}/eks_readme.md"
  
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "oidc_url" {
  value = module.eks.oidc_url
}
output "endpoint" {
  value = module.eks.endpoint
}
output "ca_certificate" {
  value = module.eks.ca_certificate
}

