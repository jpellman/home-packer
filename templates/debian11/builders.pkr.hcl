source "proxmox-iso" "proxmox" {
  http_directory = "/usr/local/srv/packer/seeds"
  boot_command = [ "<esc><wait>",
        "install <wait>",
        " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian11.cfg <wait>",
        "debian-installer=en_US.UTF-8 <wait>",
        "auto <wait>",
        "locale=en_US.UTF-8 <wait>",
        "kbd-chooser/method=us <wait>",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "netcfg/get_hostname=${local.vm_name} <wait>",
        "netcfg/get_domain=libjpel.so <wait>",
        "fb=false <wait>",
        "debconf/frontend=noninteractive <wait>",
        "console-setup/ask_detect=false <wait>",
        "console-keymaps-at/keymap=us <wait>",
        "grub-installer/bootdev=/dev/sda <wait>",
        "<enter><wait>"]
  insecure_skip_tls_verify = true
  proxmox_url = var.proxmox_url
  username = var.proxmox_username
  password = var.proxmox_password
  node = var.proxmox_node
  iso_url = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.4.0-amd64-netinst.iso"
  iso_checksum = "sha512:eeab770236777e588f6ce0f984a7f3e85d86295625010e78a0fca3e873f78188af7966b53319dde3ddcaaaa5d6b9c803e4d80470755e75796fbf0e96c973507f"
  iso_storage_pool = "local"
  vm_name = local.vm_name
  cores = var.cpu_cores
  memory = var.ram_mb
  os = "l26"
  network_adapters {
      bridge = "vmbr0"
      model = "virtio"
      firewall = false
  }
  disks {
      type = "sata"
      disk_size = "${var.disk_size_mb}M"
      storage_pool = "local-lvm"
      storage_pool_type = "lvm"
  }
  template_name = local.vm_name
  template_description  = "Debian Linux 11 template. Built from commit ${var.ansible_commit} of the Ansible repository."
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
