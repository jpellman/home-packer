#/bin/bash	
# Generates the post_install command to be run

cat > /tmp/postinstall.sh << 'EOS'
#!/bin/bash	
sed -i '/^deb cdrom:/s/^/#/' /etc/apt/sources.list
# Install Ansible
cat <<EOF > /tmp/requirements.txt
ansible==4.2.0
ansible-core==2.11.10
certifi==2020.6.20
cffi==1.15.0
cryptography==3.3.2
Jinja2==2.11.3
MarkupSafe==1.1.1
packaging==21.3
pycparser==2.20
pyparsing==3.0.8
PyYAML==5.4
resolvelib==0.5.4
six==1.15.0
EOF
pip install -r /tmp/requirements.txt

apt-get update
apt-get install -y virt-what
# https://pve.proxmox.com/wiki/Qemu-guest-agent#Linux
if [ "$(virt-what)" == "qemu" ] || [ "$(virt-what)" == "kvm" ]; then
	yum install -y qemu-guest-agent acpid
	systemctl enable qemu-guest-agent
	systemctl enable acpid
fi

# Update Ansible user settings
mkdir -p -m0700 /var/lib/ansible
chown ansible:ansible /var/lib/ansible
usermod -d /var/lib/ansible ansible
if [ -d /home/ansible ]; then
	rm -rf /home/ansible
fi
passwd -l ansible

# Add Ansible service account to sudoers
echo "ansible ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

# Install the Ansible service user's ssh key for building
# from https://github.com/vinceskahan/docs/blob/master/files/kickstart/adding-ssh-keys-in-kickstart.md
mkdir -p -m0700 /var/lib/ansible/.ssh/

cat <<EOF >/var/lib/ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjxmBtWVeCZZF/mYA7G9NVdCOtSw6OT0a2klOuOkQBLXxwfRc/f3CHlDLCXypACtcurD105MP1cAzOHGZjLAyFWmeMQKKKk1PYQSWBKq56QF47NQsuBdPFAO5FfAuj3UILNzKGaTcBHRK14o09TF2yO3dXS+F8Lg8LA7JzIMFVO0ZlCZboOJpxSc/7WPrJ+bDWz1di8RotdBwl/5xcjEwIxKwSLAWTX/nlskpLSxUWK/kXeMYUbgC3HTFrbGf7DX2g/ExZvDPA+LlPsYdrgwqv+DKMsq3hHTLUvKLyhSjj5ahpNYjmdjQeK1Lz4cJ0AgDYa/SvbxSBtI3w6zPDf1TQiie5NWzvDr2EPq/XSacTxqsBMHL6wJK27nLbqbIZFZeFCxErspFwA39AzNDqMYzPb6GLQNOJAV7EpAPpFtQn25LDpg1UT1RtBliubSX5D5e2fOGelDQaSShIfg7rLrd8FpnU96kLA7dZppZwsBjwnY1V42j4CBWpC8F61toVoxk= jpellman
EOF

### set ownership and permissions
chown -R ansible:ansible /var/lib/ansible/.ssh
chmod 0600 /var/lib/ansible/.ssh/authorized_keys
EOS
chmod +x /tmp/postinstall.sh
