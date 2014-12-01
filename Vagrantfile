# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagrant configuration for CS 4332
# Version 15

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# If you want TeamPostgreSQL, change this to 'true'
USE_TEAMPOSTGRESQL = false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # config.vm.box = "chef/ubuntu-14.04-i386"
  config.vm.box = "ubuntu/trusty32"
  config.vm.provider "parallels" do |v, override|
    override.vm.box = "parallels/ubuntu-14.04"
  end
  config.vm.provider "libvirt" do |v, override|
    override.vm.box = "baremettle/ubuntu-14.04"
  end
  
  # config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.vm.provision "shell", path: "vgresources/install.sh"

  if USE_TEAMPOSTGRESQL then
    config.vm.provision "shell", path: "vgresources/install-teampg.sh"

    config.vm.network "forwarded_port",
      guest: 8082,
      host: 9080, host_ip: "127.0.0.1",
      auto_correct: true
  end

  # We only bind to localhost for security. The VM has no security.
  config.vm.network "forwarded_port",
    guest: 5432,
    host: 5432, host_ip: "127.0.0.1",
    auto_correct: true
  config.vm.network "forwarded_port",
    guest: 5000,
    host: 5000, host_ip: "127.0.0.1",
    auto_correct: true
end
