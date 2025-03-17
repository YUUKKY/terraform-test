variable "cae-test" {default = "swr.me-east-1.myhuaweicloud.com/lw-demo/nginx:latest"}

locals {  
  configurations = [
	{
	  type = "access"
	  data = jsonencode({
	    "spec": {
          "items": [            
               {
              "type": "Ingress", # layer 7 HTTP
              "metadata": {
                "annotations": {
                  "kubernetes.io/elb.health-check-flag": "off",
                  "kubernetes.io/elb.lb-algorithm": "ROUND_ROBIN"
                }
              },
              "elb_id": "b8ae42cd-bcac-4913-87cb-542fc3dd6efe",
              "ports" : [
                {
                  "target_port" : 8080,  # based on the port listening in the code
                  "port" : 443, 
                  "protocol" : "HTTPS",
                  "default_certificate" : "pkcs8",
                  "policy" : "tls-1-2-strict", 
                  "paths" : [
                    {
                      "hostname" : "test.com",
                      "path" : "/", # URL
                      "url_match_mode" : "STARTS_WITH", # URL匹配规则
                    }
                  ]
                }
              ],
            }       
          ]
        }
	  }) 
	}
  ]
}


resource "huaweicloud_cae_application" "application_create" {
  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
  name = "terraform-test"
}

resource "huaweicloud_cae_domain" "domain_create" {
  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
  name = "test.com"
}

resource "huaweicloud_cae_component" "component_create" {
  depends_on = [huaweicloud_cae_domain.domain_create] 
  environment_id = "c48fa293-d513-4567-974a-01ca0ed2335f"
  application_id = huaweicloud_cae_application.application_create.id
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
  action = "configure"
}
