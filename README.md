# puppetconf2016
PuppetConf 2016 Vagrant Setup


Raw notes about running the demo

- manually install sublimetext packages
choco install -y ethanbrown.sublimetext2.editorpackages --version 0.2.2 --limit-output
and poshgit
choco install -y poshgit

- use script to configure client tools
.\config-client-tools.ps1 -PuppetMaster davis-master.vm

- open up a client tools compatible shell with
.\run-client-tools.ps1

- generate the access token with generate-client-tools-token.bat
  vagrant / vagrant

- push the choco 0.0.1 package up to choco feed with
  push-0.0.1.ps1

- make sure "production" branch is active and pushed to master with
  puppet-code deploy --all --wait

- then ask puppet to run on all nodes
  puppet-job run --nodes loadbalancer.vm,win2012-web-green-1,win2012-web-green-2,win2012-web-blue-1,win2012-web-blue-2

