# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Vagrant.configure("2") do |config|
  config.vm.box = 'trusty-trainee'
  config.vm.box_url = "http://dockme.cflan.net/vagrantcf/cf-ubuntu-14.04.1-server-amd_virtualbox.box"
  #it's nice to have different name shown instead of uncool default
  config.vm.define "traineeVM" do |cf|
  end

  # Make this VM reachable on the host network as well, so that other
  # VM's running other browsers can access our dev server.
  config.vm.network :private_network, ip: "192.192.192.192"

  # Make it so that network access from the vagrant guest is able to
  # use SSH private keys that are present on the host without copying
  # them into the VM.
  config.ssh.forward_agent = true
  #Supressing stdin: is not a tty
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provider :virtualbox do |v|
    # This setting gives the VM 1024MB of RAM instead of the default 384.
    v.name = "CFtraineeVM"
    v.customize ["modifyvm", :id, "--memory", [ENV['VM_MEM'].to_i, 1024].max]

    # Who has a single core cpu these days anyways?
    cpu_count = 2

    # Determine the available cores in host system.
    # This mostly helps on linux, but it couldn't hurt on MacOSX.
    if RUBY_PLATFORM =~ /linux/
      cpu_count = `nproc`.to_i
    elsif RUBY_PLATFORM =~ /darwin/
      cpu_count = `sysctl -n hw.ncpu`.to_i
    end

    # Assign additional cores to the guest OS.
    v.customize ["modifyvm", :id, "--cpus", cpu_count]
    v.customize ["modifyvm", :id, "--ioapic", "on"]

    # This setting makes it so that network access from inside the vagrant guest
    # is able to resolve DNS using the hosts VPN connection.
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder ".", "/home/vagrant/kick", id: "vagrant-root", :nfs => nfs_setting

  ##This is an operational requirements for kickstarter to run
  config.vm.provision :shell, :inline => "apt-get update && apt-get -y install libmysqld-dev nodejs && ln -nfs /var/run/mysqld/mysqld.sock /tmp/mysql.sock"

  #This is a hack to get away with nastry shell output
  # config.ssh.pty = true
  ##This is an application requirement for kickstarter to run
  config.vm.provision :shell, privileged: false, :inline => "cd /home/vagrant/kick && SHELL=/usr/bin/zsh source /home/vagrant/.zshrc > /dev/null 2>&1 && gem install bundler && bundle install && bundle exec rake db:create"
end
