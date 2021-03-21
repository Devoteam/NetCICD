// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

pipeline {
    agent none

    environment {
        JENKINS_CRED = credentials('jenkins-git')
        CML_CRED = credentials('CML-SIM-CRED')
    }

    stages {
        stage('stage: Box. Device local configuration...') {

            environment {
                STAGE = "Box"
            }

            steps {
                node ("master") {
                    echo "Switching to jenkins agent: master"

                    echo 'Collecting variables'
                    echo '--------------------'
                    echo "CML can be found on: ${CML_URL}"
                    
                    echo "The commit is on branch ${env.JOB_NAME}, with short ID: ${GIT_COMMIT[0..7]}"
                    
                    echo 'Creating Jenkins Agent'
                    thisSecret = startagent(${STAGE},${env.BUILD_NUMBER},${GIT_COMMIT[0..7]})
                    
                    echo 'Starting CML simulation'
                    startsim(${STAGE}, ${env.BUILD_NUMBER}, ${GIT_COMMIT[0..7]}, ${thisSecret})
                }
                node ("Stage: " + ${STAGE} + "-" + ${GIT_COMMIT[0..7] as String) {
                    echo "Switching to jenkins agent: ${STAGE}-${GIT_COMMIT[0..7]}"
                    
                    checkout scm

                    echo "Set stage ${STAGE} variables"
                    echo "--------------------------------------"
                    sh "cd roles/${STAGE}/vars/ && ln -s stage-${STAGE}.yml main.yml"

                    echo "Start stage ${STAGE} playbook"

                    ansiblePlaybook installation: 'ansible', inventory: 'vars/stage-${STAGE}', playbook: 'stage-${STAGE}.yml', extraVars: ["stage": ${STAGE}], extras: '-vvvv'

                }
                node ("master") {
                    echo "Switching to jenkins agent: master"
                    
                    echo 'Stopping CML simulation'
                    stopsim(${STAGE},${env.BUILD_NUMBER},${GIT_COMMIT[0..7]})
                    
                    echo 'Removing Jenkins Agent'
                    stopagent(${STAGE},${env.BUILD_NUMBER},${GIT_COMMIT[0..7]})
                }
            }
        }
        stage('stage: Topology. Device interconnection configuration on OSI L2...') {

        }
        stage('stage: Reachability. Device interconnection configuration on OSI L3...') {

        }
        stage('stage: Forwarding. MPLS/SR configuration...') {

        }
        stage('stage: Platform. MPLS/VPN platform configuration...') {

        }
        stage('stage: User domain. Customer VRF configuration...') {

        }
    }
    post {
        success {
            echo "Stage ${STAGE}, build number ${env.BUILD_NUMBER}, commit: ${GIT_COMMIT} was successful."
            //mail to: 'architect@infraautomator.example.com',
            // Evaluation between double quotes needs done to be here to see the value
            //    subject: "Stage ${STAGE} successful ${env.BUILD_NUMBER} for commit: ${GIT_COMMIT}",
            //    body: "Build is on branch ${env.JOB_NAME} for commit: ${GIT_COMMIT} "
        }
        unsuccessful {
            echo "Build number ${env.BUILD_NUMBER}, commit: ${GIT_COMMIT} failed."
            // Evaluation between double quotes needs done to be here to see the value
            //    mail to: 'architect@infraautomator.example.com',
            //    subject: "Stage ${STAGE} failed ${env.BUILD_NUMBER} for commit: ${GIT_COMMIT}",
            //    body: "Build is on branch ${env.JOB_NAME} for commit: ${GIT_COMMIT} "
        }
        changed {
            // Evaluation between double quotes needs done to be here to see the value
            echo "Stage ${STAGE} finished differently in the last build..."
        }
    }
}

def startagent(stage,build,commit) {
    echo "Creating Jenkins build node placeholder for stage: ${stage}, build: ${build} (commit:  ${commit})"
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H Content-Type:application/x-www-form-urlencoded -X POST -d \'json={"name":+"stage' + "${stage}" + "-" + "${gitCommit}" + '",+"nodeDescription":+"NetCICD+host+for+commit+is+stage'  + "${stage}" + "-"+ "${gitCommit}" + '",+"numExecutors":+"1",+"remoteFS":+"/root",+"labelString":+"slave' + "${stage}" + "-"+ "${gitCommit}" + '",+"mode":+"EXCLUSIVE",+"":+["hudson.slaves.JNLPLauncher",+"hudson.slaves.RetentionStrategy$Always"],+"launcher":+{"stapler-class":+"hudson.slaves.JNLPLauncher",+"$class":+"hudson.slaves.JNLPLauncher",+"workDirSettings":+{"disabled":+false,+"workDirPath":+"",+"internalDir":+"remoting",+"failIfWorkDirIsMissing":+false},+"tunnel":+"",+"vmargs":+""},+"retentionStrategy":+{"stapler-class":+"hudson.slaves.RetentionStrategy$Always",+"$class":+"hudson.slaves.RetentionStrategy$Always"},+"nodeProperties":+{"stapler-class-bag":+"true"},+"type":+"hudson.slaves.DumbSlave"}\' "' + "${env.JENKINS_URL}" + 'computer/doCreateItem?name="stage' + "${stage}" + "-" + "${gitCommit}" + '"&type=hudson.slaves.DumbSlave"'

    echo 'Retrieving Agent Secret'
    script {
        agentSecret = jenkins.model.Jenkins.getInstance().getComputer("stage" + "${stage}" + "-" + "$gitCommit").getJnlpMac()
    }

    return ${agentSecret}
}

def stopagent(stage,build,commit) {
    echo "Deleting Jenkins build node placeholder for stage: ${stage}, build: ${build} (commit:  ${commit})"
    sh 'curl -L -s -o /dev/null -u ' + "${JENKINS_CRED}" + ' -H "Content-Type:application/x-www-form-urlencoded" -X POST "' + "${env.JENKINS_URL}" + 'computer/stage1' + "-" + "${gitCommit}" + '/doDelete"'
    
    return null
}

def startsim(stage,build,commit) {
    echo 'Starting CML simulation for stage ' + "${stage}"
    //sh 'curl -X POST -u ' + "${CML_CRED}" + ' --header "Content-Type:text/xml;charset=UTF-8" --data-binary @virl/stage' + "${stage}" + '.virl ' + "${env.CML_URL}" + '/simengine/rest/launch?session=stage' + "${stage}" + '-' + "${gitCommit}"

    timeout(time: 30, unit: "MINUTES") {
        script {
            waitUntil {
                sleep 60
                cml_state_json = sh(returnStdout: true, script: 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}" + '/simengine/rest/nodes/stage' + "${stage}" + '-' + "${commit}").trim()
                def c_state = readJSON text: "${cml_state_json}"
                cml_state = c_state["stage" + "${stage}" + "-"+"${commit}"]
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

def stopsim(stage,build,commit) {
    echo 'Stopping CML simulation for stage ' + "${stage}"
    //sh 'curl -X GET -u ' + "${CML_CRED}" + ' ' + "${env.CML_URL}"  + '/simengine/rest/stop/stage1-' + "${gitCommit}"

    return null
}