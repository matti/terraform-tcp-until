variable "depends_id" {
  default = ""
}

variable "address" {
  type    = "string"
  default = ""
}

variable "addresses" {
  type    = "list"
  default = []
}

variable "port" {
  type = "string"
}

variable "timeout" {
  type    = "string"
  default = 1
}

variable "interval" {
  type    = "string"
  default = 1
}

variable "max_tries" {
  type    = "string"
  default = 60
}

resource "null_resource" "start" {
  triggers = {
    depends_id = "${var.depends_id}"
  }
}

data "external" "tcp" {
  depends_on = ["null_resource.start"]

  program = ["ruby", "${path.module}/tcp.rb"]

  query = {
    address   = "${var.address}"
    addresses = "${jsonencode(var.addresses)}"
    port      = "${var.port}"
    timeout   = "${var.timeout}"
    interval  = "${var.interval}"
    max_tries = "${var.max_tries}"
  }
}

output "result" {
  value = "${data.external.tcp.result}"
}
