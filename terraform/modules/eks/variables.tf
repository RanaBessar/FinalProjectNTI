variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "node_instance_types" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}

# EKS Addon Versions
variable "ebs_csi_driver_version" {
  type        = string
  description = "Version of the EBS CSI Driver addon"
  default     = "v1.28.0-eksbuild.1"
}

variable "vpc_cni_version" {
  type        = string
  description = "Version of the VPC CNI addon"
  default     = "v1.16.0-eksbuild.1"
}

variable "coredns_version" {
  type        = string
  description = "Version of the CoreDNS addon"
  default     = "v1.11.1-eksbuild.6"
}

variable "kube_proxy_version" {
  type        = string
  description = "Version of the Kube Proxy addon"
  default     = "v1.29.0-eksbuild.1"
}
