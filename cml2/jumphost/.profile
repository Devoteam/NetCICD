#!/bin/sh
if wget -q --no-check-certificate --method=HEAD https://gitea.tooling.provider.test:3000/infraautomator/; then
  echo "Setting git to Gitea." >>/home/jenkins/install-log.txt
  export GIT_URL=https://gitea.tooling.provider.test:3000/infraautomator/
else
  echo "Setting git to Github." >>/home/jenkins/install-log.txt
  export GIT_URL=https://github.com/Devoteam/
fi

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

echo '=================== Ready for modification ===================='
echo 'You can now:'
echo ' - create a branch with git branch <mybranch>'
echo ' - view which files you changed with git status'
echo ' - stage your changed files with git add'
echo ' - commit with git commit -m "<commit message>"'
echo ' - push the changes to the git server with:'
echo ''
echo ' git push --set-upstream origin <mybranch>'
echo ''
echo ' you may have to log in with your username/password'
echo ''
echo 'If you want to configure box-level: '
echo ''
echo ' ansible-playbook -i vars/stage-box stage-box.yml -e stage="box"'
echo ''
echo '========================= Have Fun! ==========================='