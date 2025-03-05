terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = ">= 1.73.0"
    }
  }
}



provider "huaweicloud" {
  region = "me-east-1"
}