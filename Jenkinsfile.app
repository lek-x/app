pipeline {
    agent any

    options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '3')
    disableConcurrentBuilds()
	timestamps ()
	}
    environment {
        GITHUB_TOKEN=credentials('github-token')
        IMAGE_NAME='lek-x/app'
        IMAGE_VERSION='1.0-d'
        BranchName = "${BRANCH_NAME}"
		TAG = sh (script: 'git tag | tail -1 | tr -d [:lower:]', returnStdout: true).trim()
    }
    stages {
        stage('Check tags') {
            steps {
				script {
				  sh(script: '''#!/bin/bash 
				     git_tag_pv=$(git rev-list --tags --skip=1 --timestamp --no-walk | sort -nr | head -n1 | cut -f 2 -d ' ' | xargs git describe --contains)    ##looking previous commit and his tag
                     git_tag_pr=$(git name-rev --name-only --tags HEAD)  ### looking current commit and his tag
                     if [[ $git_tag_pr == undefined && $git_tag_pv == v* ]]; then
                     echo 'we found a previous tag and present commit without tag'
                     stre=$git_tag_pv
                     bst=$(echo $stre | tr "v" "\n")
                     ntg=$(awk -v var="$bst" 'BEGIN {print (var+0.1)}')
                     ntg="v""$ntg"
                     echo $ntg
                     git tag -a "$ntg" -m "created by jenkins"
                     else
                     echo "tags not found"
					 #git tag -a "temp_tag" -m "created by jenkins"
                     fi
					 echo "Last tag $git_tag_pv"
				     echo "Current tag $git_tag_pr"
				  '''.stripIndent())}
                 echo "Branch name $BranchName"
				 
				 }
            } 
        stage('Test'){
            steps{
                sh "cd ${WORKSPACE}"
                sh "pylint --py3k hello.py init_db.py"
                }
            }
        stage('Cleanup'){
            steps{
                sh "sudo docker system prune -a --volumes --force"
            }
        }    
        stage('Build docker image'){
			environment{
			     TG= sh(returnStdout: true, returnStatus: false, script: 'git name-rev --name-only --tags HEAD').trim()
				 }
            steps{
			    echo "Current build tag is ${env.TG}"
                sh "cd ${WORKSPACE}"
                sh "sudo docker build . -t $IMAGE_NAME:${env.TG}"
                sh "sudo docker images"
            }    
        }
        stage('Checkin image by grype'){
            environment {
            iid = sh(returnStdout: true, returnStatus: false, script: 'sudo docker images -q $IMAGE_NAME').trim()
            }
            steps{
                echo "DEBUG ${env.iid}"
                sh "sudo grype ${env.iid} -f high"
            }
        }
        stage('login to github_con_reg'){
            steps{
                sh 'echo $GITHUB_TOKEN_PSW | sudo docker login ghcr.io -u $GITHUB_TOKEN_USR --password-stdin'
                
            }
        }
        stage('tag image'){
            steps{
                sh 'sudo docker tag $IMAGE_NAME:${env.TG} ghcr.io/$IMAGE_NAME:${env.TG}'
            }
        }
        stage('push image'){
            steps{
                sh 'sudo docker push ghcr.io/$IMAGE_NAME:${env.TG}'
            }
        }
        stage('Deploy if master'){
          when{environment name: 'BranchName', value: 'master'}
            steps{
              deploy('master')
             }
            }
        stage('Deploy if test-dev'){
          when{environment name: 'BranchName', value: 'test-dev'}
            steps{
              deploy('test-dev')
             }
            }
            
        }
    post {
        always {
            sh 'sudo docker logout'
        }
    }
}

def deploy(BranchName) {

	if ("${BranchName}" == 'master') {
           script {
             def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
             echo 'userInput: ' + userInput
             if(userInput == true) {
                echo "Start deploying"
                sh 'kubectl set image deployment/myapp myapp=ghcr.io/$IMAGE_NAME:${env.TG}'
            } else {
                echo "Action was aborted."
            }

        }
      }		
	else if ("${BranchName}" == 'test-dev') {
	    echo "Deploy to test"
		sh 'kubectl set image deployment/myapp myapp=ghcr.io/$IMAGE_NAME:${env.TG}' 
	}

}