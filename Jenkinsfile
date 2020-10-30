// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

pipeline {
    agent none
    
    environment {
        JENKINS_CRED = credentials('Jenkins-SIM')
        CML_CRED = credentials('CML-SIM-CRED')
    }
    stages {
        stage('Prepare Jenkins...') {
            agent { 
                node { 
                    label 'jenkins_node' 
                } 
            }
            steps {
                echo 'Collecting variables'
                echo '--------------------'
                echo "${env.CML_URL}"
                script { 
                    gitCommit = sh(returnStdout: true, script: 'git rev-parse --short  HEAD').trim()
                }
            }
        }
        stage('Deploying Stage 0 simulation (Box) in CML') {
            agent { 
                node { 
                    label 'jenkins_node' 
                } 
            }
            steps {
                echo "Prepare stage 0 simulation environment"
                echo "--------------------------------------"

                checkout scm

                startsim(0)
            
            }
        }
        stage('Stage 0: Deploying and testing Box in CML') {
            steps {
                node ("stage0-" + gitCommit as String) {
                    echo "Switching to jenkins agent: stage0-" + "${gitCommit}"

                    checkout scm

                    echo "Set stage 0 box variables"
                    echo "--------------------------------------"
                    sh "cd roles/box/vars/ && ln -s stage0.yml main.yml"

                    echo "Start stage 0 playbook"
                    ansiblePlaybook installation: 'ansible', inventory: 'vars/stage0', playbook: 'stage0.yml', extraVars: ["stage": "0"], extras: '-vvvv'
                }
                node ('jenkins_node') {
                    echo "Switching to jenkins agent: jenkins_node"

                    echo 'Stopping CML simulation'
                    sh 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}"  + '/simengine/rest/stop/stage0-' + "${gitCommit}"

                    echo 'Removing Jenkins Agent'
                    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H "Content-Type:application/x-www-form-urlencoded" -X POST "' + "${env.JENKINS_URL}" + 'computer/stage0' + "-" + "${gitCommit}" + '/doDelete"'
                }
            }
        }
        stage('Deploying Stage 1 simulation (Topology) in CML') {
            agent { 
                node { 
                    label 'jenkins_node' 
                } 
            }
            steps {
                echo "Prepare stage 1 simulation environment"
                echo "--------------------------------------"

                checkout scm

                startsim(1)
            
            }
        }
        stage('Stage 1: Configuring interfaces and links in CML') {
            steps {
                node ("stage1-" + gitCommit as String) {
                    echo "Switching to jenkins agent: stage1-" + "${gitCommit}"

                    checkout scm

                    echo "Set stage 1 topology variables"
                    echo "--------------------------------------"
                    sh "cd roles/box/vars/ && ln -s stage1.yml main.yml"
                    sh "cd roles/topology/vars/ && ln -s stage1.yml main.yml"

                    echo "Start stage 0 playbook"
                    ansiblePlaybook installation: 'ansible', inventory: 'vars/stage1', playbook: 'stage0.yml', extraVars: ["stage": "1"]

                    echo "Start stage 1 playbook"
                    ansiblePlaybook installation: 'ansible', inventory: 'vars/stage1', playbook: 'stage1.yml', extraVars: ["stage": "1"], extras: '-vvvv'
                }
                node ('jenkins_node') {
                    echo "Switching to jenkins agent: jenkins_node"

                    echo 'Stopping CML simulation'
                    sh 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}"  + '/simengine/rest/stop/stage1-' + "${gitCommit}"

                    echo 'Removing Jenkins Agent'
                    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H "Content-Type:application/x-www-form-urlencoded" -X POST "' + "${env.JENKINS_URL}" + 'computer/stage1' + "-" + "${gitCommit}" + '/doDelete"'
                }
            }
        }
     }
    post {
        success {
            echo 'I succeeded!'
            //mail to: 'architects@example.com',
            //    subject: "Success for Pipeline: ${gitCommit}",
            //    body: "Success for ${env.BUILD_URL}"
        }
        failure {
            echo 'You are not a Jedi yet....I failed :('
            //    mail to: 'architects@example.com',
            //    subject: "Failed Pipeline: ${gitCommit}",
            //    body: "Something is wrong with ${env.BUILD_URL}"
        }
        changed {
            echo 'Things were different before...'
        }
        cleanup {
            echo 'Cleaning up....'
        }
    }
}


def startsim(stage) {
    echo 'Creating Jenkins build node for commit: ' + "${gitCommit}"
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H Content-Type:application/x-www-form-urlencoded -X POST -d \'json={"name":+"stage' + "${stage}" + "-" + "${gitCommit}" + '",+"nodeDescription":+"NetCICD+host+for+commit+is+stage'  + "${stage}" + "-"+ "${gitCommit}" + '",+"numExecutors":+"1",+"remoteFS":+"/root",+"labelString":+"slave' + "${stage}" + "-"+ "${gitCommit}" + '",+"mode":+"EXCLUSIVE",+"":+["hudson.slaves.JNLPLauncher",+"hudson.slaves.RetentionStrategy$Always"],+"launcher":+{"stapler-class":+"hudson.slaves.JNLPLauncher",+"$class":+"hudson.slaves.JNLPLauncher",+"workDirSettings":+{"disabled":+false,+"workDirPath":+"",+"internalDir":+"remoting",+"failIfWorkDirIsMissing":+false},+"tunnel":+"",+"vmargs":+""},+"retentionStrategy":+{"stapler-class":+"hudson.slaves.RetentionStrategy$Always",+"$class":+"hudson.slaves.RetentionStrategy$Always"},+"nodeProperties":+{"stapler-class-bag":+"true"},+"type":+"hudson.slaves.DumbSlave"}\' "' + "${env.JENKINS_URL}" + 'computer/doCreateItem?name="stage' + "${stage}" + "-" + "${gitCommit}" + '"&type=hudson.slaves.DumbSlave"'
  
    echo 'Retrieving Agent Secret'
    script {
        agentSecret = jenkins.model.Jenkins.getInstance().getComputer("stage" + "${stage}" + "-" + "$gitCommit").getJnlpMac()
    }
    echo "secret = " + "${agentSecret}"

    echo "Inserting jenkins url in docker jumphost configuration"
    sh "sed -i 's%jenkins_url%" + "${env.JENKINS_URL}" + "%g' virl/stage" + "${stage}" + ".virl"

    echo "Inserting agent secret in docker jumphost configuration"
    sh "sed -i 's/jenkins_secret/" + "${agentSecret}" + "/g' virl/stage" + "${stage}" + ".virl"
   
    echo "Configuring Jenkins agent to use"
    sh "sed -i 's/jenkins_agent/stage" + "${stage}" + "-" + "${gitCommit}" + "/g' virl/stage" + "${stage}" + ".virl"

    echo 'Starting CML simulation for stage ' + "${stage}"
    sh 'curl -X POST -u ' + "${CML_CRED}" + ' --header "Content-Type:text/xml;charset=UTF-8" --data-binary @virl/stage' + "${stage}" + '.virl ' + "${env.CML_URL}" + '/simengine/rest/launch?session=stage' + "${stage}" + '-' + "${gitCommit}"

    timeout(time: 30, unit: "MINUTES") {
        script {
            waitUntil {
                sleep 60
                cml_state_json = sh(returnStdout: true, script: 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}" + '/simengine/rest/nodes/stage' + "${stage}" + '-' + "${gitCommit}").trim()
                def c_state = readJSON text: "${cml_state_json}"
                cml_state = c_state["stage" + "${stage}" + "-"+"${gitCommit}"]
                //echo "${cml_state}"
                cs = cml_state.collect {it.value.reachable}
                echo "Node reachability: " + "${cs}"
                test =  cs.every {element -> element == true}
                echo "Simulation ready? " + "${test}"
                if (test) {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    return null
}