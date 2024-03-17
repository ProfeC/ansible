terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  # url is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. my proxmox host is 'prox-1u'. Add /api2/json at the end for the API
  pm_api_url = var.proxmox_host["api_url"]

  # api token id is in the form of: <username>@pam!<tokenId>
  pm_api_token_id = var.proxmox_host["api_token_id"]

  # this is the full secret wrapped in quotes. don't worry, I've already deleted this from my proxmox cluster by the time you read this post
  pm_api_token_secret = var.proxmox_host["api_token_secret"]

  # leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  pm_tls_insecure = true

  # (Optional; defaults to 4) Allowed simultaneous Proxmox processes (e.g. creating resources).
  pm_parallel = 2
}

# resource is formatted to be "[type]" "[entity_name]" so in this case we are looking to create a proxmox_vm_qemu entity named test_server
resource "proxmox_vm_qemu" "server" {
  for_each = var.servers
  # another variable with contents 
  clone      = var.template_name
  full_clone = true
  name       = "kube-${each.key}"

  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host["node"]

  # basic VM settings here. agent refers to guest agent
  agent = 1
  cores = each.value["cores"]
  cpu   = "host"
  desc  = "This was generated with terraform"
  # force_create = true # force recreation during testing.
  memory  = each.value["memory"]
  numa    = true
  onboot  = true
  os_type = "cloud-init"
  sockets = each.value["sockets"]
  vcpus   = 0
  vmid    = each.value["vmid"]

  bootdisk                = "scsi0"
  cloudinit_cdrom_storage = "datahog"
  scsihw                  = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = each.value["disk_size"]
          storage = "datahog"
          # iothread = true
        }
      }
    }
  }

  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model   = "virtio"
    bridge  = "vmbr0"
    tag     = 20
    macaddr = each.value["mac_addr"]
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network, usb,
    ]
  }

  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)

  # ipconfig0 = "ip=192.168.20.2${count.index + 1}/24,gw=192.168.20.1"
  ipconfig0 = ""

  # Cloudinit user
  ciuser = "serveradmin"

  # # sshkeys set using variables. the variable contains the text of the key.
  # sshkeys = <<EOF
  # ${var.ssh_key}
  # EOF
}

resource "proxmox_vm_qemu" "storage" {
  for_each                = var.storage
  agent                   = 1
  bootdisk                = "scsi0"
  clone                   = var.template_name
  cloudinit_cdrom_storage = "datahog"
  cores                   = each.value["cores"]
  cpu                     = "host"
  desc                    = "This was generated with terraform"
  full_clone              = true
  memory                  = each.value["memory"]
  name                    = "kube-${each.key}"
  numa                    = true
  onboot                  = true
  os_type                 = "cloud-init"
  scsihw                  = "virtio-scsi-single"
  sockets                 = each.value["sockets"]
  target_node             = var.proxmox_host["node"]
  vcpus                   = 0
  vmid                    = each.value["vmid"]

  disks {
    scsi {
      scsi0 {
        disk {
          size    = each.value["disk_size"]
          storage = "datahog"
          # iothread = true
        }
      }
    }
  }

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    tag     = 20
    macaddr = each.value["mac_addr"]
  }

  lifecycle {
    ignore_changes = [
      network, usb,
    ]
  }

  # ipconfig0 = "ip=192.168.20.2${count.index + 1}/24,gw=192.168.20.1"
  ipconfig0 = ""

  # Cloudinit user
  ciuser = "serveradmin"
}
