#!/bin/sh
git config --global user.name "netcicd-pipeline"
git config --global user.email "netcicd-pipeline@infraautomator.example.net"
git clone ${GIT_URL}NetCICD.git
cd NetCICD
git status
echo '====================== Preparing CML lab ======================'
cd roles/box/vars
ln -s stage-box.yml main.yml
cd ~/NetCICD 
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
