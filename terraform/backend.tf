terraform {

  backend "s3" {
    bucket         = var.bucket_name
    key            = "eks-cluster/terraform.tfstate"  
    region         = var.region
    encrypt        = true
    dynamodb_table = "terraform-state-lock" 
  }

}
