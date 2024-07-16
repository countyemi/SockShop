variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
    description = "EKS Cluster Name"
    type = string
    default = "SockShop-Cluster"
  
}

variable "AZ" {
    description = "Cluster Availability Zones"
    type = list(string)
    default = [ "us-east-1a", "us-east-1b" ]
  
}

variable "bucket_name" {
  
  type = string
  default = "bald-eagle-sockshop-state-2433"
  
}
