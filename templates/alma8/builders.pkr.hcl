source "proxmox-iso" "proxmox" {
  http_directory = "/usr/local/srv/packer/seeds"
  boot_command = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/alma8.cfg<enter><wait>"] 
  insecure_skip_tls_verify = true
  proxmox_url = var.proxmox_url
  username = var.proxmox_username
  password = var.proxmox_password
  node = var.proxmox_node
  # We use CentOS 8.2 here because of a bug with multipath volumes:
  # https://www.reddit.com/r/CentOS/comments/l1iyjt/started_cancel_waiting_for_multipath_sibling_of/
  # https://bugzilla.redhat.com/show_bug.cgi?id=1916168
  #iso_url = "https://vault.centos.org/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-boot.iso"
  #iso_checksum = "sha256:c67876a5602faa17f68b40ccf2628799b87454aa67700f0f57eec15c6ccdd98c"
  iso_url = "http://nyc.mirrors.clouvider.net/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-boot.iso"
  iso_checksum = "sha256:de92004fcc5bb5b9af586c9b5ab0e0c7c5a5eedce4d2be85156c5dd31a4fa81b"
  iso_storage_pool = "local"
  vm_name = local.vm_name
  cores = var.cpu_cores
  memory = var.ram_mb
  os = "l26"
  network_adapters {
      bridge = "vmbr0"
      model = "virtio"
      mac_address = "A8:A1:59:A7:2C:37"
      firewall = true
  }
  disks {
      type = "sata"
      disk_size = "${var.disk_size_mb}M"
      storage_pool = "local-lvm"
      storage_pool_type = "lvm"
  }
  template_name = local.vm_name
  template_description  = "Alma Linux 8 template. Built from commit ${var.ansible_commit} of the Ansible repository."
  boot_wait = "10s"
  ssh_username = "ansible"
  ssh_timeout = "15m"
  ssh_private_key_file = "/usr/local/etc/ansible/.ssh/ansible-rsa"
  ssh_port = 22
  qemu_agent = true
  task_timeout = "15m"
}

build {
  sources = ["source.proxmox-iso.proxmox"]
  provisioner "ansible-local" {
    playbook_file = "/usr/local/etc/ansible/playbook-base.yml"
    group_vars = "/usr/local/etc/ansible/group_vars"
    inventory_groups = ["base-template"]
    clean_staging_directory = true
  }
}
