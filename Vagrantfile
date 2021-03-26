Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
  end
  config.vm.define "nfs-server" do |subconfig|
    subconfig.vm.box = "ubuntu/bionic64"
  end
  config.vm.provision :shell, path: "nfs-server.sh", run: 'always'

  config.vm.network "public_network", bridge: [
      "wlp2s0"
  ]
  config.vm.provision "shell" do |s|
    ssh_prv_key = ""
    ssh_pub_key = ""
    if File.file?("#{Dir.home}/.ssh/id_rsa")
      ssh_prv_key = File.read("#{Dir.home}/.ssh/id_rsa")
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    else
      puts "No SSH key found. You will need to remedy this before pushing to the repository."
    end
    s.inline = <<-SHELL
      if grep -sq "#{ssh_pub_key}" /home/vagrant/.ssh/authorized_keys; then
        echo "SSH keys already provisioned."
        exit 0;
      fi
      echo "SSH key provisioning."
      mkdir -p /home/vagrant/.ssh/
      mkdir -p /root/.ssh/
      chmod 700 /root/.ssh/
      touch /root/.ssh/authorized_keys
      touch /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      echo #{ssh_pub_key} > /root/.ssh/id_rsa.pub 
      echo #{ssh_pub_key} > /home/vagrant/.ssh/id_rsa.pub
      chmod 644 /home/vagrant/.ssh/id_rsa.pub
      chmod 644 /root/.ssh/id_rsa.pub
      echo "#{ssh_prv_key}" > /home/vagrant/.ssh/id_rsa
      echo "#{ssh_prv_key}" > /root/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/id_rsa
      chmod 600 /root/.ssh/id_rsa
      chown -R vagrant:vagrant /home/vagrant
      exit 0
    SHELL
  end

end
