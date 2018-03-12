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

module "multi_80" {
  source = ".."

  addresses = ["example.com", "google.com"]
  port      = 80
}

output "example_80" {
  value = "${module.example_80.result}"
}

output "multi_80" {
  value = "${module.multi_80.result}"
}
