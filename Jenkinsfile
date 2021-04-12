// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import groovy.json.JsonSlurper 

def this_stage = "None"
def gitCommit = ""
def cml_token = "12345"
def lab_id = "1"
def agentName = ""

pipeline {
    agent none

    environment {
        JENKINS_CRED = credentials('jenkins-jenkins')
        CML_CRED = credentials('CML-SIM-CRED')
    }

    stages {
        stage('stage: Box. Device local configuration...') {
            agent { 
                node { 
                    label 'master' 
                } 
            }

            stages {
                stage ('Collecting variables') {
                    steps {             
                        script {
                            this_stage = "box"
                            gitCommit = "${env.GIT_COMMIT[0..7]}"
                        }
                        // Collect CML token first
                        script {
                            cml_token = sh(returnStdout: true, script: 'curl -k -X POST "${CML_URL}/api/v0/authenticate" -H  "accept: application/json" -H  "Content-Type: application/json" -d \'{"username":"' + "${CML_CRED_USR}" + '","password":"' + "${CML_CRED_PSW}" + '"}\'').trim()                             
                        }                       
                        echo "The commit is on branch ${env.JOB_NAME}, with short ID: ${gitCommit}"
                        echo 'Creating Jenkins Agent'
                        script {
                            thisSecret = startagent("${this_stage}","${env.BUILD_tag}","${gitCommit}")
                        }
                        echo 'Starting CML simulation'
                        script {
                            lab_id = startsim("${this_stage}","${env.BUILD_NUMBER}", "${gitCommit}", "${thisSecret}", "${cml_token}")
                        }
                        echo "Lab ${lab_id} is operational."
                        script {
                            agentName = "stage-${this_stage}-${gitCommit}"
                        }
                        echo "The next stage agent is: ${agentName}"
                    }
                }
                stage ('Preparing playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        echo "Switched to jenkins agent: stage-${this_stage}-${gitCommit}"
                        checkout scm
                        echo "Set stage ${this_stage} variables"
                        sh "cd roles/${this_stage}/vars/ && ln -s stage-${this_stage}.yml main.yml"
                    }
                }
                stage('Running playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        echo "Start stage ${this_stage} playbook on lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: 'vars/stage-box', playbook: 'stage-box.yml', extraVars: ["stage": "box"], extras: '-vvvv'
                    }
                }
                stage ('Testing') {
                    agent {
                        label agentName
                    }
                    steps {
                        echo "Testing stage ${this_stage}" 
                        //robot outputPath: '.', logFileName: '${this_stage}_log.html', outputFileName: '${this_stage}.xml', reportFileName: '${this_stage}_report.hml', passThreshold: 100, unstableThreshold: 75.0
                        //archiveArtifacts artifacts: '**/*', fingerprint: true
                        //junit 'build/reports/**/*.xml'
                    }
                }
                stage ('Cleaning up') {
                    steps {
                        echo "Switched to jenkins agent: master"
                        echo "Stopping CML simulation on lab ${lab_id}"
                        stopsim("${this_stage}", "${env.BUILD_tag}", "${gitCommit}", "${lab_id}", "${cml_token}")   
                        echo 'Removing Jenkins Agent'
                        stopagent("${this_stage}","${env.BUILD_tag}","${gitCommit}")
                        deleteDir() /* clean up our workspace */
                    }
                }
            }
        }
        // stage('stage: Topology. Device interconnection configuration on OSI L2...') {

        // }
        // stage('stage: Reachability. Device interconnection configuration on OSI L3...') {

        // }
        // stage('stage: Forwarding. MPLS/SR configuration...') {

        // }
        // stage('stage: Platform. MPLS/VPN platform configuration...') {

        // }
        // stage('stage: User domain. Customer VRF configuration...') {

        // }
    }
    post {
        always {
            echo "Archiving artifacts"
            //archiveArtifacts artifacts: '**/*', fingerprint: true
            //junit 'build/reports/**/*.xml'
        }
        success {
            echo "Build ${env.BUILD_tag}, commit: ${gitCommit} was successful."
            //mail to: 'architect@infraautomator.example.com',
            //subject: "Build ${env.BUILD_tag}, commit: ${gitCommit} was successful.",
            //body: "Build is on branch ${env.JOB_NAME}"
        }
        unsuccessful {
            echo "Build ${env.BUILD_tag}, commit: ${gitCommit} failed."
            //mail to: 'architect@infraautomator.example.com',
            //subject: "Build ${env.BUILD_tag}, commit: ${gitCommit} was successful.",
            //body: "Build is on branch ${env.JOB_NAME}"
        }
        changed {
            echo "${env.JOB_NAME} finished differently in the last build..."
        }
    }
}

def startagent(stage, build, commit) {
    echo "Creating Jenkins build node placeholder for stage: ${stage}, build: ${build} (commit:  ${commit})"
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H Content-Type:application/x-www-form-urlencoded -X POST -d \'json={"name":+"stage' + "${stage}" + "-" + "${commit}" + '",+"nodeDescription":+"NetCICD+host+for+commit+is+stage-'  + "${stage}" + "-"+ "${commit}" + '",+"numExecutors":+"1",+"remoteFS":+"/home/cisco",+"labelString":+"slave' + "${stage}" + "-"+ "${commit}" + '",+"mode":+"EXCLUSIVE",+"":+["hudson.slaves.JNLPLauncher",+"hudson.slaves.RetentionStrategy$Always"],+"launcher":+{"stapler-class":+"hudson.slaves.JNLPLauncher",+"$class":+"hudson.slaves.JNLPLauncher",+"workDirSettings":+{"disabled":+false,+"workDirPath":+"",+"internalDir":+"remoting",+"failIfWorkDirIsMissing":+false},+"tunnel":+"",+"vmargs":+""},+"retentionStrategy":+{"stapler-class":+"hudson.slaves.RetentionStrategy$Always",+"$class":+"hudson.slaves.RetentionStrategy$Always"},+"nodeProperties":+{"stapler-class-bag":+"true"},+"type":+"hudson.slaves.DumbSlave"}\' "' + "${env.JENKINS_URL}" + 'computer/doCreateItem?name="stage-' + "${stage}" + "-" + "${commit}" + '"&type=hudson.slaves.DumbSlave"'

    echo 'Retrieving Agent Secret'
    script {
        agentSecret = jenkins.model.Jenkins.getInstance().getComputer("stage-" + "${stage}" + "-" + "$commit").getJnlpMac()
    }

    return "${agentSecret}"
}

def stopagent(stage, build, commit) {
    echo "Deleting Jenkins build node placeholder for stage: ${stage}, build: ${build} (commit:  ${commit})"
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H "Content-Type:application/x-www-form-urlencoded" -X POST "' + "${env.JENKINS_URL}" + 'computer/stage-' + "${stage}" + "-" + "${commit}" + '/doDelete"'
    
    return null
}

def startsim(stage, build, commit, secret, token) {
    def lab = ""
    echo "Starting CML simulation for build ${build}, stage ${stage}"
    echo "Agent secret: ${secret}"

    // Insert the agent_secret into the yaml file
    echo "Inserting agent secret in agent configuration"
    sh "sed -i 's/jenkins_secret/" + "${secret}" + "/g' cml2/stage-" + "${stage}" + ".yaml"
   
    echo "Inserting agent name in agent configuration"
    sh "sed -i 's/jenkins_agent/stage-" + "${stage}" + "-" + "${commit}" + "/g' cml2/stage-" + "${stage}" + ".yaml"
    
    //we need to collect the lab_id in order to be able to stop the lab.
    script {
        response = sh(returnStdout: true, script: 'curl -k -X POST ' + "${env.CML_URL}" + '/api/v0/import?title=stage-' + "${stage}" + '-' + "${commit}" + ' -H  "accept: application/json" -H  "Authorization: Bearer ' + "${token}" + '" -H  "Content-Type: application/json" --data-binary @cml2/stage-' + "${stage}" + '.yaml').trim()
        def jsonSlurper = new JsonSlurper()
        def alllab = jsonSlurper.parseText("${response}")
        lab = "${alllab.id}"
    }
    echo "The lab stage-${stage}-${commit} imported with id ${lab}. Starting the simulation."
    script {
        response = sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/start" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()
        echo "Lab started ${response}"
    }
    waitUntil {
        if (sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/check_if_converged" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"')) {
        return true
        } else {
        return false
        }
    }

    timeout(time: 30, unit: "MINUTES") {
        script {
            waitUntil {
                sleep 60
                cml_state_json = sh(returnStdout: true, script: 'curl -k -X GET "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/lab_element_state" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()
                def jsonSlurper = new JsonSlurper()
                def cstate = jsonSlurper.parseText("${cml_state_json}").nodes
                echo "${cstate}"
                cs = cstate.collect {it.value}
                echo "Node status: " + "${cs}"
                def test = cs.every {element -> element == "BOOTED"}
                echo "Simulation ready? " + "${test}"
                if (test) {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    return "${lab}"
}

def stopsim(stage, build, commit, lab, token) {
    echo "Stopping CML simulation for build ${build}, stage ${stage}"
    script {
        response = sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/stop" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()        
        echo "${response}" 
        waitUntil {
            if (sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/check_if_converged" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"')) {
                 return true
                 } else {
                     return false
                 }
        }
        echo "Lab stopped, wiping lab."
        response = sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/wipe" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()        
        echo "${response}" 
        waitUntil {
            if (sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '/check_if_converged" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"')) {
                 return true
                 } else {
                     return false
                 }
        }
        echo "Lab wiped."
        response = sh(returnStdout: true, script: 'curl -k -X DELETE "' + "${env.CML_URL}" + '/api/v0/labs/' + "${lab}" + '" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()
        echo "${response}" 
        echo "Lab deleted"        
    }
     
    return null
}
