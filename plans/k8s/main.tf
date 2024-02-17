terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  # url is the hostname (FQDN if you have one) for the proxmox host you'd like to connect to to issue the commands. my proxmox host is 'prox-1u'. Add /api2/json at the end for the API
  pm_api_url = "https://192.168.1.11:8006/api2/json"

  # api token id is in the form of: <username>@pam!<tokenId>
  pm_api_token_id = "root@pam!terraform"

  # this is the full secret wrapped in quotes. don't worry, I've already deleted this from my proxmox cluster by the time you read this post
  pm_api_token_secret = "27f5f065-97cf-458b-817e-19451852e394"

  # leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  pm_tls_insecure = true
}

# resource is formatted to be "[type]" "[entity_name]" so in this case
# we are looking to create a proxmox_vm_qemu entity named test_server
resource "proxmox_vm_qemu" "test_server" {
  count = 1 # just want 1 for now, set to 0 and apply to destroy VM

  name = "test-vm-${count.index + 1}" #count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox

  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host

  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.template_name

  # basic VM settings here. agent refers to guest agent
  agent = 0
  bootdisk = "scsi0"
  ciuser = "serveradmin"
  cloudinit_cdrom_storage = "fast-storage"
  cores = 2
  cpu = "host"
  desc = "This was generated with terraform"
  memory = 2048
  numa = true
  os_type = "cloud-init"
  # scsihw = "virtio-scsi-pci"
  scsihw   = "virtio-scsi-single" 
  sockets = 2
  vcpus = 0
  vmid = 800

  disks {
    scsi {
      scsi0 {
        disk {
          size = 10
          storage = "datahog"
          # iothread = true
        }
      }
    }
  }
  
  # if you want two NICs, just copy this whole network section and duplicate it
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = 20
    # macaddr = "B3:F5:02:23:6F:3F"
    macaddr = "BC:24:11:0B:25:F2"
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  
  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.98.1.91 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)

  # ipconfig0 = "ip=10.98.1.9${count.index + 1}/24,gw=10.98.1.1"
  
  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
