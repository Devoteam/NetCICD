// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import groovy.json.JsonSlurper

this_stage = "None"
gitCommit = ""
cml_token = "12345"
thisSecret = "verysecret"
lab_id = "1"
agentName = ""

pipeline {
    agent none

    environment {
        JENKINS_CRED = credentials('jenkins-jenkins')
        CML_CRED = credentials('CML-SIM-CRED')
        NEXUS_CRED = credentials('jenkins-nexus')
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
                        varscollection("box")
                    }
                }
                stage ('Preparing playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        prepare("${this_stage}", "${gitCommit}")
                    }
                }
                stage('Running playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        echo "Prepare lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

                        echo "Start stage ${this_stage} playbook on lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
                    }
                }
                stage ('Testing') {
                    agent {
                        label agentName
                    }
                    steps {
                        teststep ("${this_stage}")
                    }
                }
                stage ('Cleaning up') {
                    steps {
                        cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
                    }
                }
            }
        }
        stage('stage: Topology. Device interconnection configuration on OSI L2...') {
            agent { 
                node { 
                    label 'master' 
                } 
            }
            stages {
                stage ('Collecting variables') {
                    steps {
                        varscollection("topology")
                    }
                }
                stage ('Preparing playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        prepare("${this_stage}", "${gitCommit}")
                    }
                }
                stage('Running playbook') {
                    agent {
                        label agentName
                    }
                    steps {
                        echo "Prepare lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

                        echo "Start stage Box playbook on lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-box.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

                        echo "Start stage ${this_stage} playbook on lab ${lab_id}"
                        ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
                    }
                }
                stage ('Testing') {
                    agent {
                        label agentName
                    }
                    steps {
                        teststep ("${this_stage}")
                    }
                }
                stage ('Cleaning up') {
                    steps {
                        cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
                    }
                }
            }
        }
        // stage('stage: Reachability. Device interconnection configuration on OSI L3...') {
        //     agent { 
        //         node { 
        //             label 'master' 
        //         } 
        //     }
        //     stages {
        //         stage ('Collecting variables') {
        //             steps {
        //                 varscollection("platform")
        //             }
        //         }
        //         stage ('Preparing playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 prepare("${this_stage}", "${gitCommit}")
        //             }
        //         }
        //         stage('Running playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 echo "Prepare lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Box playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-box.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Topology playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-topology.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage ${this_stage} playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
        //             }
        //         }
        //         stage ('Testing') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 teststep ("${this_stage}")
        //             }
        //         }
        //         stage ('Cleaning up') {
        //             steps {
        //                 cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
        //             }
        //         }
        //     }
        // }
        // stage('stage: Forwarding. MPLS/SR configuration...') {
        //     agent { 
        //         node { 
        //             label 'master' 
        //         } 
        //     }
        //     stages {
        //         stage ('Collecting variables') {
        //             steps {
        //                 varscollection("platform")
        //             }
        //         }
        //         stage ('Preparing playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 prepare("${this_stage}", "${gitCommit}")
        //             }
        //         }
        //         stage('Running playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 echo "Prepare lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Box playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-box.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Topology playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-topology.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Reachability playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-reachability.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage ${this_stage} playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
        //             }
        //         }
        //         stage ('Testing') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 teststep ("${this_stage}")
        //             }
        //         }
        //         stage ('Cleaning up') {
        //             steps {
        //                 cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
        //             }
        //         }
        //     }
        // }
        // stage('stage: Platform. MPLS/VPN platform configuration...') {
        //     agent { 
        //         node { 
        //             label 'master' 
        //         } 
        //     }
        //     stages {
        //         stage ('Collecting variables') {
        //             steps {
        //                 varscollection("platform")
        //             }
        //         }
        //         stage ('Preparing playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 prepare("${this_stage}", "${gitCommit}")
        //             }
        //         }
        //         stage('Running playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 echo "Prepare lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Box playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-box.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Topology playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-topology.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Reachability playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-reachability.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Forwarding playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-forwarding.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage ${this_stage} playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
        //             }
        //         }
        //         stage ('Testing') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 teststep ("${this_stage}")
        //             }
        //         }
        //         stage ('Cleaning up') {
        //             steps {
        //                 cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
        //             }
        //         }
        //     }
        // }
        // stage('stage: User domain. Customer VRF configuration...') {
        //     agent { 
        //         node { 
        //             label 'master' 
        //         } 
        //     }
        //     stages {
        //         stage ('Collecting variables') {
        //             steps {
        //                 varscollection("user")
        //             }
        //         }
        //         stage ('Preparing playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 prepare("${this_stage}", "${gitCommit}")
        //             }
        //         }
        //         stage('Running playbook') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 echo "Prepare lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'prepare.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Box playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-box.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Topology playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-topology.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Reachability playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-reachability.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Forwarding playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-forwarding.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage Platform playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: 'stage-platform.yml', extraVars: ["stage": "${this_stage}"], extras: '-vvvv'

        //                 echo "Start stage ${this_stage} playbook on lab ${lab_id}"
        //                 ansiblePlaybook installation: 'ansible', inventory: "vars/stage-${this_stage}", playbook: "stage-${this_stage}.yml", extraVars: ["stage": "${this_stage}"], extras: '-vvvv'
        //             }
        //         }
        //         stage ('Testing') {
        //             agent {
        //                 label agentName
        //             }
        //             steps {
        //                 teststep ("${this_stage}")
        //             }
        //         }
        //         stage ('Cleaning up') {
        //             steps {
        //                 cleanup("${lab_id}", "${this_stage}", "${gitCommit}", "${cml_token}")
        //             }
        //         }
        //     }
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
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H Content-Type:application/x-www-form-urlencoded -X POST -d \'json={"name":+"stage' + "${stage}" + "-" + "${commit}" + '",+"nodeDescription":+"NetCICD+host+for+commit+is+stage-'  + "${stage}" + "-"+ "${commit}" + '",+"numExecutors":+"1",+"remoteFS":+"/home/ubuntu",+"labelString":+"slave' + "${stage}" + "-"+ "${commit}" + '",+"mode":+"EXCLUSIVE",+"":+["hudson.slaves.JNLPLauncher",+"hudson.slaves.RetentionStrategy$Always"],+"launcher":+{"stapler-class":+"hudson.slaves.JNLPLauncher",+"$class":+"hudson.slaves.JNLPLauncher",+"workDirSettings":+{"disabled":+false,+"workDirPath":+"",+"internalDir":+"remoting",+"failIfWorkDirIsMissing":+false},+"tunnel":+"",+"vmargs":+""},+"retentionStrategy":+{"stapler-class":+"hudson.slaves.RetentionStrategy$Always",+"$class":+"hudson.slaves.RetentionStrategy$Always"},+"nodeProperties":+{"stapler-class-bag":+"true"},+"type":+"hudson.slaves.DumbSlave"}\' "' + "${env.JENKINS_URL}" + 'computer/doCreateItem?name="stage-' + "${stage}" + "-" + "${commit}" + '"&type=hudson.slaves.DumbSlave"'

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
    
    // Inserting tool IP addresses in the lab
    echo "Inserting gitea IP address in jumphost configuration"
    sh "sed -i 's/gitea_ip/" + "${env.GITEA_IP}" + "/g' cml2/stage-" + "${stage}" + ".yaml"

    echo "Inserting jenkins IP address in jumphost configuration"
    sh "sed -i 's/jenkins_ip/" + "${env.JENKINS_IP}" + "/g' cml2/stage-" + "${stage}" + ".yaml"

    echo "Inserting nexus IP address in jumphost configuration"
    sh "sed -i 's/nexus_ip/" + "${env.NEXUS_IP}" + "/g' cml2/stage-" + "${stage}" + ".yaml"


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
    echo "Waiting for the simulation to stabilize and the agent to come up";
    // sleep 300;
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

def varscollection(stage) {
    script {
        // Set global variables
        this_stage = "${stage}"
        gitCommit = "${env.GIT_COMMIT[0..7]}"
    
        // Collect CML token
        cml_token = sh(returnStdout: true, script: 'curl -k -X POST "${CML_URL}/api/v0/authenticate" -H  "accept: application/json" -H  "Content-Type: application/json" -d \'{"username":"' + "${CML_CRED_USR}" + '","password":"' + "${CML_CRED_PSW}" + '"}\'').trim()                             
    }                       
    echo "The commit is on branch ${env.JOB_NAME}, with short ID: ${gitCommit}"
    echo 'Creating Jenkins Agent'
    script {
        thisSecret = startagent("${stage}","${env.BUILD_tag}","${gitCommit}")
    }
    echo 'Starting CML simulation'
    script {
        lab_id = startsim("${stage}","${env.BUILD_NUMBER}", "${gitCommit}", "${thisSecret}", "${cml_token}")
    }
    echo "Lab ${lab_id} is operational."
    script {
        agentName = "stage-${this_stage}-${gitCommit}"
    }
    echo "The next stage agent is: ${agentName}"

    return null
}

def prepare(stage, commit) {
    echo "Switched to jenkins agent: stage-${stage}-${commit}"
    checkout scm
    echo "Set stage ${stage} variables"
    sh "cd roles/${stage}/vars/ && ln -s stage-${stage}.yml main.yml"

    return null
}

def teststep(stage) {
    echo "Testing stage ${stage}" 
    robot outputPath: "roles/${stage}/files", logFileName: "${stage}_unittest_log.html", outputFileName: "${stage}_unittest.xml", reportFileName: "${stage}_unittest_report.html", passThreshold: 100, unstableThreshold: 75.0
    script { 
        nexus_test_upload = sh(returnStdout: true, script: 'curl -v -u ' + "${NEXUS_CRED}" + ' --upload-file roles/' + "${stage}" + '/files/' + "${stage}" + '_unittest.xml http://nexus:8081/repository/NetCICD-reports/' + "${gitCommit}" + '/' + "${this_stage}" + '_unittest.xml').trim()
        nexus_log_upload = sh(returnStdout: true, script: 'curl -v -u ' + "${NEXUS_CRED}" + ' --upload-file roles/' + "${stage}" + '/files/' + "${stage}" + '_unittest_log.html http://nexus:8081/repository/NetCICD-reports/' + "${gitCommit}" + '/' + "${this_stage}" + '_unittest_log.html').trim()
        nexus_report_upload = sh(returnStdout: true, script: 'curl -v -u ' + "${NEXUS_CRED}" + ' --upload-file roles/' + "${stage}" + '/files/' + "${stage}" + '_unittest_report.html http://nexus:8081/repository/NetCICD-reports/' + "${gitCommit}" + '/' + "${this_stage}" + '_unittest_report.html').trim()
    }
    echo "Test uploaded: ${nexus_test_upload}"
    echo "Test log uploaded: ${nexus_log_upload}"
    echo "Test report uploaded: ${nexus_report_upload}"

    return null
}

def cleanup(lab, stage, commit, token) {
    echo "Switched to jenkins agent: master"
    echo "Stopping CML simulation on lab ${lab}"
    stopsim("${stage}", "${env.BUILD_tag}", "${commit}", "${lab}", "${token}")   
    echo 'Removing Jenkins Agent'
    stopagent("${stage}","${env.BUILD_tag}","${commit}")
    deleteDir() /* clean up our workspace */

    return null
}