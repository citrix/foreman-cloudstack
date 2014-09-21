# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bgalura/foreman-1.5"

  $cloudstackscript = <<SCRIPT
#!/usr/bin/env bash
cd /automation/cloudstack
mvn -Pdeveloper -pl developer -Ddeploydb
mvn -Pdeveloper -pl developer -Ddeploydb-simulator
mysql -uroot cloud -e "update configuration set value = 'false' where name = 'router.version.check';"
mysql -uroot cloud -e "update user set api_key = 'F0Hrpezpz4D3RBrM6CBWadbhzwQMLESawX-yMzc5BCdmjMon3NtDhrwmJSB1IBl7qOrVIT4H39PTEJoDnN-4vA' where id = 2;"
mysql -uroot cloud -e "update user set secret_key = 'uWpZUVnqQB4MLrS_pjHCRaGQjX62BTk_HU8uiPhEShsY7qGsrKKFBLlkTYpKsg1MzBJ4qWL0yJ7W7beemp-_Ng' where id = 2;"
nohup mvn -pl client jetty:run -Dsimulator &

# Deploy zone
while ! nc -vz localhost 8080; do sleep 10; done # Wait for CloudStack to start
unset MAVEN_OPTS
mvn -Pdeveloper,marvin.setup -Dmarvin.config=../../vagrant/simulator-advanced.cfg -pl :cloud-marvin integration-test
CS_ZONE_ID=$(cloudmonkey list zones | jgrep -s zone.id)
# TODO:
# cloudmonkey lookup CS_TEMPLATE_ID
# cloudmonkey create isolated network and get CS_NETWORK_ID
# create foreman computeresource zone1-vagrant
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/v2/compute_resources -d '{
  "compute_resource": {
    "name": "cloudstack-test",
    "provider": "Cloudstack",
    "url": "http://192.168.56.6:8080/client/api",
    "user": "F0Hrpezpz4D3RBrM6CBWadbhzwQMLESawX-yMzc5BCdmjMon3NtDhrwmJSB1IBl7qOrVIT4H39PTEJoDnN-4vA",
    "password": "uWpZUVnqQB4MLrS_pjHCRaGQjX62BTk_HU8uiPhEShsY7qGsrKKFBLlkTYpKsg1MzBJ4qWL0yJ7W7beemp-_Ng"
  }
}'
# create image inside compute resource, production, CentOS 5.3, userdata enabled



SCRIPT

  $foremanscript = <<SCRIPT
echo I am provisioning foreman...
pkill -9 ruby
mysql -u root -ppassword -e 'drop database foreman'
mysql -u root -ppassword -e 'create database foreman'
foreman-rake db:migrate
foreman-rake db:seed
cd /vagrant
tar czf /usr/share/foreman/cloudstack-cr.tgz app/
cd /usr/share/foreman
tar xvzf cloudstack-cr.tgz
echo >> /etc/foreman/settings.yaml
echo :cloudstack: true >> /etc/foreman/settings.yaml

service foreman restart
chkconfig foreman on
service iptables stop 
chkconfig iptables off 
yum -y install nc --enablerepo=epel

while ! nc -vz localhost 3000; do sleep 10; done # Wait for foreman to start

# create foreman group base
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/hostgroups -d '{
  "hostgroup": {
    "name": "base"
  }
}'
# create foreman domain cs.test.internal 
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/domains -d '{
  "domain": {
    "name": "cs.test.internal"
  }
}'
# create foreman env  production
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/environments -d '{
  "environment": {
    "name": "production"
  }
}'
# create foreman OS CentOS 
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/v2/operatingsystems -d '{
    "operatingsystem": {
        "name": "CentOS",
        "major": "5",
        "minor": "3"
    }
}'
# link this OS to an arch
curl -s -X PUT -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/architectures/1 -d '{
    "architecture": {
        "name": "x86_64",
        "operatingsystem_ids": [
            "1",
            ""
        ]
    }
}'
# create foreman provisioning template userdata 
curl -s -X POST -H "Content-Type:application/json" -H "Accept:application/json" -k -u admin:changeme http://192.168.56.4:3000/api/v2/config_templates -d '{
    "config_template": {
        "name": "test",
        "template": "test",
        "audit_comment": "",
        "snippet": "0",
        "template_kind_id": "7",
        "operatingsystem_ids": [
            "1",
            ""
        ]
    }
}'
# TODO: associate userdata template with production env


CS_API_KEY='F0Hrpezpz4D3RBrM6CBWadbhzwQMLESawX-yMzc5BCdmjMon3NtDhrwmJSB1IBl7qOrVIT4H39PTEJoDnN-4vA'
CS_API_SECRET='uWpZUVnqQB4MLrS_pjHCRaGQjX62BTk_HU8uiPhEShsY7qGsrKKFBLlkTYpKsg1MzBJ4qWL0yJ7W7beemp-_Ng'

mkdir /root/.cloudmonkey
cat > /root/.cloudmonkey/config << CMCONFIG
[core]
profile = local
asyncblock = true
history_file = /root/.cloudmonkey/history
log_file = /root/.cloudmonkey/log
cache_file = /root/.cloudmonkey/cache
paramcompletion = true

[ui]
color = true
prompt = >
display = json
 
[local]
url = http://192.168.56.6:8080/client/api
username = admin
password = password
timeout = 3600
expires = 600

CMCONFIG

SCRIPT

  config.vm.define "app" do |foremanmysql| 
    foremanmysql.vm.network "private_network", ip: "192.168.56.4"
    foremanmysql.vm.network "forwarded_port", guest: 3000, host: 3000 
    foremanmysql.vm.provision :shell, inline: $foremanscript 
    foremanmysql.vm.box = "bgalura/foreman1.5"
    foremanmysql.vm.provider "virtualbox" do |v|
      v.memory = 2048 
    end
  end
    
  config.vm.define "cloudstack" do |cloudstack|
    cloudstack.vm.boot_timeout = 600
    cloudstack.vm.network "private_network", ip: "192.168.56.6"
    cloudstack.vm.network "forwarded_port", guest: 8080, host: 8080
    cloudstack.vm.box = "bgalura/cloudstack-simulator-4.3.0-forward"
    cloudstack.vm.provision :shell, inline: $cloudstackscript 
    cloudstack.vm.provider "virtualbox" do |v|
      v.memory = 1024 
    end
  end 

  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

end
