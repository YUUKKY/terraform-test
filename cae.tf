variable "cae-test" {default = "swr.me-east-1.myhuaweicloud.com/demo-cae/cae-frontend:1.0.0"}

locals {  
  configurations = [
	{
	  type = "access"
	  data = jsonencode({
	    "spec": {
          "items": [            
               {
              "type": "LoadBalancer", # layer 7 HTTP
              "metadata": {
                "annotations": {
                  "kubernetes.io/elb.health-check-flag": "on",
                  "kubernetes.io/elb.lb-algorithm": "ROUND_ROBIN"
                }
              },
              "elb_id": "defaultElbID",
              "ports": [
              {
                "port": 443,
                "protocol": "HTTPS",
                "default_certificate": "test1",
                "policy": "tls-1-2-strict",
                "target_port": 80,
                "hostname": "",
                "paths": [
                {
                    "path": "/",
                    "url_match_mode": "STARTS_WITH"
                }
                ]
              }
            ]
            }
          ]
        }
	  }) 
	}
  ]
}

resource "huaweicloud_cae_component" "component_create" {
  environment_id = "f8df9907-4633-448f-8db5-918f8e433ee2"
  application_id = "46c1bf1b-40b5-4354-a688-cbaff9beeb6d"
  deploy_after_create = true

  metadata {
    name = "application"

    annotations = {
      version = "1.0.0"
    }
  }

  dynamic "configurations" {
    for_each = local.configurations
    content {
      type = configurations.value.type
      data = configurations.value.data
    }
  }

  spec {
    runtime = "Docker"
    replica = 1

    source {
      type = "image"
      url  = var.cae-test
    }

    resource_limit {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
  # action = "upgrade"
}
