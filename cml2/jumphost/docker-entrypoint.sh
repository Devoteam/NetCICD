#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

if [ ! -d "/home/jenkins/.ssh" ]; then
  mkdir -p /home/jenkins/.ssh
fi

cd /home/jenkins
if $(curl --output /dev/null --silent --head --insecure --fail https://jenkins.tooling.provider.test:8084/whoAmI); then
  wget --no-check-certificate https://jenkins.tooling.provider.test:8084/jnlpJars/agent.jar
  echo "NetCICD Toolbox installed. Retrieved agent.jar from NetCICD-Developer-Toolbox."  >>/home/jenkins/install-log.txt
  agent=1
  chown jenkins:jenkins agent.jar
  echo $J_SECRET > secret-file
  chown jenkins:jenkins secret-file
  sudo -H -u jenkins java -jar agent.jar -jnlpUrl https://jenkins.tooling.provider.test:8084/computer/jenkins_agent/jenkins-agent.jnlp -secret @secret-file -workDir "/home/jenkins" -noCertificateCheck &
else
  echo "NetCICD Toolbox not installed. Skipping Jenkins agent start." >>/home/jenkins/install-log.txt
fi

if wget -q --no-check-certificate --method=HEAD https://gitea.tooling.provider.test:3000/infraautomator/ ; then
  echo "Setting git to Gitea." >>/home/jenkins/install-log.txt
  export GIT_URL=https://gitea.tooling.provider.test:3000/infraautomator/
else
  echo "Setting git to Github." >>/home/jenkins/install-log.txt
  export GIT_URL=https://github.com/Devoteam/
fi

ansible-galaxy collection install cisco.ios -p /home/jenkins/.ansible/collections/ >>/home/jenkins/install-log.txt
ansible-galaxy collection install cisco.iosxr -p /home/jenkins/.ansible/collections/ >>/home/jenkins/install-log.txt
ansible-galaxy collection install cisco.nxos -p /home/jenkins/.ansible/collections/ >>/home/jenkins/install-log.txt

ssh-keygen -t rsa -N "" -f /home/jenkins/.ssh/id_rsa -C netcicd-pipeline@infraautomator.provider.test

if wget -q --no-check-certificate --method=HEAD https://gitea.tooling.provider.test:3000/infraautomator/; then
  echo "Setting git to Gitea." >>/home/jenkins/install-log.txt
  export GIT_URL=https://gitea.tooling.provider.test:3000/infraautomator/
else
  echo "Setting git to Github." >>/home/jenkins/install-log.txt
  export GIT_URL=https://github.com/Devoteam/
fi

chown -R jenkins:jenkins /home/jenkins

if grep -q prepared NetCICD_state; then
    echo "Lab already prepared"
else
    git config --global user.name "netcicd-pipeline"
    git config --global user.email "netcicd-pipeline@infraautomator.example.net"
    git -c http.sslVerify=false clone ${GIT_URL}NetCICD.git
    cd NetCICD
    git status
    echo '====================== Preparing CML lab ======================'
    cd roles/box/vars
    ln -s stage-box.yml main.yml
    cd ~/NetCICD
    ansible-playbook -i vars/stage-box prepare.yml -e stage="box"
    echo "prepared" > ../NetCICD_state
fi
exec "$@"
