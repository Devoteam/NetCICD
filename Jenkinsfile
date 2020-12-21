// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

pipeline {
    agent none
    options{timestamps()}
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
            options{timestamps()}
            steps {
                echo 'Collecting variables'
                echo '--------------------'
                echo "CML can be found on: ${CML_URL}"
                echo "This is build number ${env.BUILD_NUMBER}, commit: ${GIT_COMMIT}"
                echo "The commit is on branch ${env.JOB_NAME}, with short ID: ${GIT_COMMIT[0..7]}"
            }
        }
    }
    post {
        success {
            echo 'I succeeded!'
            //mail to: 'architect@infraautomator.example.com',
            //    subject: "Successful build ${env.BUILD_NUMBER} for commit: ${GIT_COMMIT}",
            //    body: "Build is on branch ${env.JOB_NAME} for commit: ${GIT_COMMIT} "
        }
        failure {
            echo 'You are not a Jedi yet....I failed :('
            //    mail to: 'architect@infraautomator.example.com',
            //    subject: "Failed build ${env.BUILD_NUMBER} for commit: ${GIT_COMMIT}",
            //    body: "Build is on branch ${env.JOB_NAME} for commit: ${GIT_COMMIT} "
        }
        changed {
            echo 'Things were different before...'
        }
        cleanup {
            echo 'Cleaning up....'
        }
    }
}
