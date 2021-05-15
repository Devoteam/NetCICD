#!/bin/sh
git config --global user.name "netcicd-pipeline"
git config --global user.email "netcicd-pipeline@infraautomator.example.net"
git clone ${GIT_URL}NetCICD.git
cd NetCICD
git status
echo '====================== Preparing CML lab ======================'
ansible-playbook -i vars/stage-reachability prepare.yml
echo '================  Starting stage Box playbook  ================'
cd roles/box/vars
ln -s stage-reachability.yml main.yml
cd ~/NetCICD 
git status
ansible-playbook -i vars/stage-reachability stage-box.yml -e stage="reachability"
echo '============== Starting stage Topology playbook ==============='
cd roles/topology/vars
ln -s stage-reachability.yml main.yml
cd ~/NetCICD 
git status
ansible-playbook -i vars/stage-reachability stage-topology.yml -e stage="reachability"
echo '============ Starting stage Reachability playbook ============='
cd roles/reachability/vars
ln -s stage-reachability.yml main.yml
cd ~/NetCICD 
git status
ansible-playbook -i vars/stage-reachability stage-reachability.yml -e stage="reachability"
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
echo '========================= Have Fun! ==========================='
