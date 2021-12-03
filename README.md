# tf-map-variable-in-ws-tfe202111-1
Reproduction/testing for the complex type variables in TFE 202111-1, for example - map, defined on workspaces

# Assumption to test

We plan to pass variable "additional_tags" (workspace variable ) as input parameters during resource creation.
We have define variables.tf as

```Terraform
variable "additional_tags" {
 description = "additional custom tags"
 type = map(string)
 default = {
  team = "terraform-automation"
 }
}
```

We are able to get this working when we use file "terraform.auto.tfvars" with below entry
additional_tags = { team : "mydev" } but when we try to pass this as input variable of our workspace in terraform enterprise, we are not able to get it working. ( TFE v 202111-1 )


# Testing

Code that is passing with default values defined inline : 

```Terraform
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
```

Output of this code in TFE : 

```Terraform
Terraform v1.0.9
on linux_amd64
Initializing plugins and modules...
random_pet.demo: Creating...
random_pet.demo: Creation complete after 0s [id=comic-aardvark]
null_resource.test-out: Creating...
null_resource.test-out: Provisioning with 'local-exec'...
null_resource.test-out (local-exec): Executing: ["/bin/sh" "-c" "echo comic-aardvark"]
null_resource.test-out (local-exec): comic-aardvark
null_resource.test-out: Creation complete after 0s [id=328409270240018218]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

demo = "comic-aardvark"
```

# Test with reassigning variable at the workspace leve in TFE

## Failing output examples : 

If the variable defineds the map in the ".tfvars" syntax it is going to fail. Let's test by assifgining on the workspace new variable in tbhe same way as in the initial claim :

```Terraform
{ team : "mydev" }
```

E.g. we are using colon to separate key index from value in map. and that is no a syntatically correct HCL 
Output of the plan going to be : 

```Terraform
terraform apply
Running apply in the remote backend. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://ag-vars-test.guselietov.com/app/map-var-test/test-1/runs/run-rZDcGxJjwr64ctZt

Waiting for the plan to start...

Terraform v1.0.9
on linux_amd64
Configuring remote state backend...
Initializing Terraform configuration...
╷
│ Error: Invalid value for input variable
│
│   on /terraform/terraform.tfvars line 1:
│    1: additional_tags = "\"{ team : \"mydev\" }\""
│
│ The given value is not valid for variable "additional_tags": map of string
│ required.
```

## Working output and definition example : 

If variable defined with HCL checbox and in pure HCL with euqal sign connecting key and value in the map like this : 
```
{ team = "mydev" }
```

The output going to be : 

```Terraform
Running apply in the remote backend. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://ag-vars-test.guselietov.com/app/map-var-test/test-1/runs/run-e6xnunLNQZ1SJKLp

Waiting for 1 run(s) to finish before being queued...

Terraform v1.0.9
on linux_amd64
Configuring remote state backend...
Initializing Terraform configuration...

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.test-out will be created
  + resource "null_resource" "test-out" {
      + id       = (known after apply)
      + triggers = (known after apply)
    }

  # random_pet.demo will be created
  + resource "random_pet" "demo" {
      + id        = (known after apply)
      + length    = 2
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + demo = (known after apply)
  + tags = {
      + "team" = "mydev"
    }

random_pet.demo: Creating...
random_pet.demo: Creation complete after 0s [id=sought-hagfish]
null_resource.test-out: Creating...
null_resource.test-out: Provisioning with 'local-exec'...
null_resource.test-out (local-exec): Executing: ["/bin/sh" "-c" "echo sought-hagfish"]
null_resource.test-out (local-exec): sought-hagfish
null_resource.test-out: Creation complete after 0s [id=3277697029909571187]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

demo = "sought-hagfish"
tags = tomap({
  "team" = "mydev"
})
```

Which is correct.




# TODO

- [x] deploy TFE v202111-1
- [x] make repo
- [x] make reproducal code
- [x] confirm or deny the claim

