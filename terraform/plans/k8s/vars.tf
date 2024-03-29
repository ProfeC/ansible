variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtmsr35Syy1YILOvsOnsXqUG7gdzz5FWmpiC0TNhD0dbehsamuetfUjlmOTaJzz1US93aBFsVDmE89R7XeWMqUjRzvDYE1RrW6QvDN+pHKOqyzqvoPuJmKE4L9HRpcLKj6Jn8SoFhzRBwu96tgg/99XWEQ8MSgyoGD728CIe9iWqvfJB0Z6wNK72YSGe1sF6JleUNvjmmEumSgIwIcAQ4kzFEowt8m41jhWhhEHz4Yv6LYzHILZmMqpAswzPXdNhkXp4wPnh5fw8BMRZtJnwp2MkpKLik5N6uNi/EtyRU/mW0H/9jyYr0rVeSiJt3SQgiDiuR/3iMI7pmMqmLjcCWzaQ12qZR2YhZrMOfvydpLZMGPZH2zm4CdColHw03Kg/NWS+IoJC94NNlyM5wkDJCVV2TdLcC+xeXEopto5f9y6SiRg5QueiJ01oIAvjCcl42mZ2wu1suviwjDCT3nbZG8URRdWJQ3FszOFyUP2TMEzNDtpsU+oe7zG9Y9tmBdNDk= clarkgar@shu-t480s-clarkgar"
}

variable "proxmox_host" {
  type = map(any)
  default = {
    node             = "morpheus"
    api_url          = "https://192.168.1.11:8006/api2/json"
    api_token_id     = "root@pam!terraform"
    api_token_secret = "27f5f065-97cf-458b-817e-19451852e394"
  }
}

variable "template_name" {
  # default = "debian12-cloud" # vmid 9001
  default = "debian12-cloud-template" # vmid 9003
}

variable "gateway" {
  type    = string
  default = "192.168.20.1"
}

variable "servers" {
  type = map(object({
    cores     = number
    disk_size = number
    ip_addr   = string
    mac_addr  = string
    memory    = number
    sockets   = number
    vmid      = number
  }))
  default = {
    # admin = {
    #   cores     = 2
    #   disk_size = 25
    #   ip_addr   = "192.168.20.8"
    #   mac_addr  = "bc:24:11:80:e6:be"
    #   memory    = 2048
    #   sockets   = 1
    #   vmid      = 500
    # }

    server1 = {
      cores     = 2
      disk_size = 25
      ip_addr   = "192.168.20.10"
      mac_addr  = "bc:24:11:e6:6a:ec"
      memory    = 4096
      sockets   = 2
      vmid      = 501
    }

    server2 = {
      cores     = 2
      disk_size = 25
      ip_addr   = "192.168.20.11"
      mac_addr  = "bc:24:11:42:16:72"
      memory    = 4096
      sockets   = 2
      vmid      = 502
    }

    server3 = {
      cores     = 2
      disk_size = 25
      ip_addr   = "192.168.20.12"
      mac_addr  = "bc:24:11:e0:60:70"
      memory    = 4096
      sockets   = 2
      vmid      = 503
    }

    agent1 = {
      cores     = 2
      disk_size = 50
      ip_addr   = "192.168.20.13"
      mac_addr  = "bc:24:11:1d:ff:40"
      memory    = 8192
      sockets   = 2
      vmid      = 504
    }

    agent2 = {
      cores     = 2
      disk_size = 50
      ip_addr   = "192.168.20.14"
      mac_addr  = "bc:24:11:bf:39:8a"
      memory    = 8192
      sockets   = 2
      vmid      = 505
    }
  }
}

variable "storage" {
  type = map(object({
    cores     = number
    disk_size = number
    ip_addr   = string
    mac_addr  = string
    memory    = number
    sockets   = number
    vmid      = number
  }))
  default = {
    storage1 = {
      cores     = 2
      disk_size = 50
      ip_addr   = "192.168.20.19"
      mac_addr  = "bc:24:11:0b:25:f1"
      memory    = 4096
      sockets   = 2
      vmid      = 510
    }

    storage2 = {
      cores     = 2
      disk_size = 50
      ip_addr   = "192.168.20.20"
      mac_addr  = "bc:24:11:54:0e:43"
      memory    = 4096
      sockets   = 2
      vmid      = 511
    }
    
    storage3 = {
      cores     = 2
      disk_size = 50
      ip_addr   = "192.168.20.21"
      mac_addr  = "bc:24:11:e4:68:f1"
      memory    = 4096
      sockets   = 2
      vmid      = 512
    }
  }
}

variable "node_token" {
  type    = string
  default = "K1023b72a50743ad645186e91cf190adddccc0a925103eb0e66a36bc2051df9902e::server:077c602842e9c1107fc74a694dd0d0c0"
}
