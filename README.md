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


# TODO

- [x] deploy TFE v202111-1
- [x] make repo
- [x] make reproducal code
- [ ] confirm or deny the claim

