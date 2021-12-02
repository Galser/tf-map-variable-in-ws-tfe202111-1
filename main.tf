terraform {
  backend "remote" {
    hostname     = "ag-vars-test.guselietov.com"
    organization = "map-var-test"

    workspaces {
      name = "test-1"
    }
  }
}

variable "additional_tags" {
  description = "additional custom tags"
  type        = map(string)
  default = {
    team = "terraform-automation"
  }
}

resource "random_pet" "demo" {}

resource "null_resource" "test-out" {
  triggers = {
    pet_name = random_pet.demo.id
  }

  provisioner "local-exec" {
    command = "echo ${random_pet.demo.id}"
  }
}

output "demo" {
  value = random_pet.demo.id
}

