terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = ">= 1.73.0"
    }
  },
  backend "s3" {  
    bucket = "cae-riyadh-demo"
    key    = "cae-riyadh-demo/terraform.tfstate"  
    region = "me-east-1"      
    endpoint = "https://obs.me-east-1.myhuaweicloud.com"    
    
    skip_region_validation = true
    skip_credentials_validation = true
    skip_metadata_api_check = true    
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}



provider "huaweicloud" {
  region = "me-east-1"
}
