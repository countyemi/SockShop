terraform {

  backend "s3" {
    bucket         = var.bucket_name
    key            = "eks-cluster/terraform.tfstate"  
    region         = "us-east-1"
    encrypt        = true
    
  }

}
