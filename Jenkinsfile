// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import groovy.json.JsonSlurper

def this_stage = "None"
def gitCommit = ""
def cml_token = "12345"
def lab_id = "1"

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
                            this_stage = "Box"
                            gitCommit = "${env.GIT_COMMIT[0..7]}"
                        }
                        //sh 'printenv'
                        echo "CML can be found on: ${env.CML_URL}"
                        
                        // Collect CML token first
                        script {
                            cml_token = sh(returnStdout: true, script: 'curl -k -X POST "https://192.168.32.148/api/v0/authenticate" -H  "accept: application/json" -H  "Content-Type: application/json" -d \'{"username":"' + "${CML_CRED_USR}" + '","password":"' + "${CML_CRED_PSW}" + '"}\'').trim()                             
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
                        
                        echo "Lab is ${lab_id}"
                        
                    }
                }
                stage ('Preparing playbook') {
                    //agent {
                    //    label ${this_stage} + "-" + ${gitCommit} as String
                    //}
                    steps {
                        echo "Switched to jenkins agent: stage-${this_stage}-${gitCommit}"
                        checkout scm
                        echo "Set stage ${this_stage} variables"
                        //sh "cd roles/${this_stage}/vars/ && ln -s stage-${this_stage}.yml main.yml"
                    }
                }
                stage('Running playbook') {
                    //agent {
                    //    label ${this_stage} + "-" + ${gitCommit} as String
                    //}
                    steps {
                        echo "Start stage ${this_stage} playbook on lab ${lab_id}"
                        //ansiblePlaybook installation: 'ansible', inventory: 'vars/stage-${this_stage}', playbook: 'stage-${this_stage}.yml', extraVars: ["stage": ${this_stage}], extras: '-vvvv'
                    }

                }
                stage ('Cleaning up') {
                    steps {
                        echo "Switched to jenkins agent: master"
                        echo "Stopping CML simulation on lab ${lab_id}"
                        stopsim("${this_stage}", "${env.BUILD_tag}", "${gitCommit}", "${lab_id}", "${cml_token}")   
                        echo 'Removing Jenkins Agent'
                        stopagent("${this_stage}","${env.BUILD_tag}","${gitCommit}")
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
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H Content-Type:application/x-www-form-urlencoded -X POST -d \'json={"name":+"stage' + "${stage}" + "-" + "${commit}" + '",+"nodeDescription":+"NetCICD+host+for+commit+is+stage'  + "${stage}" + "-"+ "${commit}" + '",+"numExecutors":+"1",+"remoteFS":+"/root",+"labelString":+"slave' + "${stage}" + "-"+ "${commit}" + '",+"mode":+"EXCLUSIVE",+"":+["hudson.slaves.JNLPLauncher",+"hudson.slaves.RetentionStrategy$Always"],+"launcher":+{"stapler-class":+"hudson.slaves.JNLPLauncher",+"$class":+"hudson.slaves.JNLPLauncher",+"workDirSettings":+{"disabled":+false,+"workDirPath":+"",+"internalDir":+"remoting",+"failIfWorkDirIsMissing":+false},+"tunnel":+"",+"vmargs":+""},+"retentionStrategy":+{"stapler-class":+"hudson.slaves.RetentionStrategy$Always",+"$class":+"hudson.slaves.RetentionStrategy$Always"},+"nodeProperties":+{"stapler-class-bag":+"true"},+"type":+"hudson.slaves.DumbSlave"}\' "' + "${env.JENKINS_URL}" + 'computer/doCreateItem?name="stage-' + "${stage}" + "-" + "${commit}" + '"&type=hudson.slaves.DumbSlave"'

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
    def thislab = ""
    echo "Starting CML simulation for build ${build}, stage ${stage}"
    echo "Agent secret: ${secret}"
    // Insert the agent_secret into the yaml file

    //we need to collect the lab_id in order to be able to stop the lab.
    script {
        response = sh(returnStdout: true, script: 'curl -k -X POST ' + "${env.CML_URL}" + '/api/v0/import?title=stage-' + "${stage}" + '-' + "${commit}" + ' -H  "accept: application/json" -H  "Authorization: Bearer ' + "${token}" + '" -H  "Content-Type: application/json" --data-binary @cml2/NetCICD-' + "${stage}" + '.yaml').trim()
        echo "${response}"
        def jsonSlurper = new JsonSlurper()
        def lab = jsonSlurper.parseText("${response}")
        thislab = "${lab.id}"
    }
    echo "The lab stage-${stage}-${commit} imported with id ${thislab}. Starting the simulation."
    script {
        response = sh(returnStdout: true, script: 'curl -k -X PUT "' + "${env.CML_URL}" + '/api/v0/labs/' + "${thislab}" + '/start" -H "accept: application/json" -H "Authorization: Bearer ' + "${token}" + '"').trim()
        echo "Lab started ${response}"
    }

    // timeout(time: 30, unit: "MINUTES") {
    //     script {
    //         waitUntil {
    //             sleep 60
    //             cml_state_json = sh(returnStdout: true, script: 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}" + '/simengine/rest/nodes/stage' + "${stage}" + '-' + "${commit}").trim()
    //             def c_state = readJSON text: "${cml_state_json}"
    //             cml_state = c_state["stage" + "${stage}" + "-"+"${commit}"]
    //             //echo "${cml_state}"
    //             cs = cml_state.collect {it.value.reachable}
    //             echo "Node reachability: " + "${cs}"
    //             test =  cs.every {element -> element == true}
    //             echo "Simulation ready? " + "${test}"
    //             if (test) {
    //                 return true
    //             } else {
    //                 return false
    //             }
    //         }
    //     }
    // }
    return "${thislab}"
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