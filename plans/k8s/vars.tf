variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtmsr35Syy1YILOvsOnsXqUG7gdzz5FWmpiC0TNhD0dbehsamuetfUjlmOTaJzz1US93aBFsVDmE89R7XeWMqUjRzvDYE1RrW6QvDN+pHKOqyzqvoPuJmKE4L9HRpcLKj6Jn8SoFhzRBwu96tgg/99XWEQ8MSgyoGD728CIe9iWqvfJB0Z6wNK72YSGe1sF6JleUNvjmmEumSgIwIcAQ4kzFEowt8m41jhWhhEHz4Yv6LYzHILZmMqpAswzPXdNhkXp4wPnh5fw8BMRZtJnwp2MkpKLik5N6uNi/EtyRU/mW0H/9jyYr0rVeSiJt3SQgiDiuR/3iMI7pmMqmLjcCWzaQ12qZR2YhZrMOfvydpLZMGPZH2zm4CdColHw03Kg/NWS+IoJC94NNlyM5wkDJCVV2TdLcC+xeXEopto5f9y6SiRg5QueiJ01oIAvjCcl42mZ2wu1suviwjDCT3nbZG8URRdWJQ3FszOFyUP2TMEzNDtpsU+oe7zG9Y9tmBdNDk= clarkgar@shu-t480s-clarkgar"
}

variable "proxmox_host" {
  default = "morpheus"
}

variable "template_name" {
  default = "debian12-cloud"
}
