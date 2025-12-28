terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "3.7.0"
    }
  }

  backend "s3" {
    region = "ap-northeast-1"
    bucket = "rishikawa-gha-terraform-poc"
    key    = "terraform.tfstate"
  }
}
