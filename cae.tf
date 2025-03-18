variable "cae-test" {default = "swr.me-east-1.myhuaweicloud.com/lw-demo/nginx:latest"}

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
         "operator": "",
         "uid": "b04d7e6f-3e55-4578-b0ec-c67e8d193300",
         "ip": "",
         "name": "",
         "target_port": 80,
         "port": 80,
         "protocol": "TCP",
         "default_certificate": ""
        }
       ],
            }       
          ]
        }
	  }) 
	}
  ]
}


#resource "huaweicloud_cae_application" "application_create" {
#  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
#  name = "terraform-test"
#}

#resource "huaweicloud_cae_domain" "domain_create" {
#  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
#  name = "test.com"
#}

resource "huaweicloud_cae_component" "component_create" {
  #depends_on = [huaweicloud_cae_domain.domain_create] 
  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
  #application_id = huaweicloud_cae_application.application_create.id
  application_id = "5cc74cdb-e264-4a63-885d-541ca27fbf56"
  #deploy_after_create = true

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
  action = "configure"
}
