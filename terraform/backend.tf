terraform {

  backend "s3" {
    bucket         =  "bald-eagle-sockshop-state-2433"
    key            = "eks-cluster/terraform.tfstate"  
    region         = "us-east-1"
    encrypt        = true
    
  }

}
