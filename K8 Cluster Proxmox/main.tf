terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.50.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.90.250:8006/"
  username = "root@pam"
  password = "Benhur12"
  insecure = true


  ssh {
    agent = false
    username = "root"
  }
}