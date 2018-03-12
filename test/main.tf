module "example_80" {
  source = ".."

  address = "example.com"
  port    = 80
}

# module "example_81" {
#   source = ".."

#   address   = "example.com"
#   port      = 81
#   max_tries = 2
#   interval  = 1
# }

output "example_80" {
  value = "${module.example_80.result}"
}
