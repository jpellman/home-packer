variable "proxmox_url" {
  type =  string
  default = "https://hypervisor01.libjpel.so/api2/json"
}

variable "proxmox_username" {
  type =  string
  default = "packerserv@pve"
}

variable "proxmox_password" {
  type =  string
  default = env("PROXMOX_PASSWORD")
  sensitive = true
}

variable "proxmox_node" {
  type =  string
  default = "hypervisor01"
}

variable "ansible_commit" {
  type =  string
  default = env("ANSIBLE_COMMIT")
}

variable "cpu_cores" {
  type =  number
  default = 2
}

variable "ram_mb" {
  type =  number
  default = 2048
}

variable "disk_size_mb" {
  type =  string
  default = "12288"
}

locals {
  vm_name = "homelab-debian-11-${formatdate("YYYY-MM-DD",timestamp())}"
}
