# pipeline
self hosted pipeline

# prerequisites:
Ubuntu 20.04
desktop environment, e.g. ubuntu-desktop
VMware Workstation (not VMware Player)
Vagrant
GitHub Actions runner

# setting up
0. ubuntu desktop
```shell
apt install ubuntu-desktop
```

1. VMware Workstation prerequisites
```shell
sudo apt install gcc build-essential
```

2. VMware Workstation 
https://www.vmware.com/de/products/workstation-pro/workstation-pro-evaluation.html
```shell
curl https://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-16.1.2-17966106.x86_64.bundle -o VMware-Workstation-Full-16.1.2-17966106.x86_64.bundle
./VMware-Workstation-Full-16.1.2-17966106.x86_64.bundle
```

3. Vagrant - DO NOT USE OS PACKAGE MANAGER
https://www.vagrantup.com/docs/installation

4. Vagrant VMware Utilities
https://www.vagrantup.com/docs/providers/vmware/vagrant-vmware-utility
```
curl https://releases.hashicorp.com/vagrant-vmware-utility/1.0.20/vagrant-vmware-utility_1.0.20_x86_64.deb -o vagrant-vmware-utility_1.0.20_x86_64.deb
```

5. GitHub Actions runner
```
cd github_actions_runner/actions-runner
curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
```

6. `github_actions_runner/.env`
```shell
ORGANIZATION=    github organization
REPOSITORY_NAME= github repository name
GITHUB_TOKEN=    github developer token
```

7. [OPTIONAL] VMs number
```./vagrant/Vagrantfile```

replace `5` with desired VMs number

```
...
  (1..5).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
...
```

8. Deployment
```shell
cd ./vagrant
vagrant up
```
