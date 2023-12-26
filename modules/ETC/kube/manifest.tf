
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}


data "kubectl_path_documents" "docs" {
    pattern = var.manifests_Path
}

resource "kubectl_manifest" "eks" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
}