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
        IMAGE_VERSION='1.0-b'
        BranchName = "${BRANCH_NAME}"
    }
    stages {
        stage('Debug') {
            steps {
                 echo "$BranchName"}
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
            steps{
                sh "cd ${WORKSPACE}"
                sh "sudo docker build . -t $IMAGE_NAME:$IMAGE_VERSION"
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
                sh 'sudo docker tag $IMAGE_NAME:$IMAGE_VERSION ghcr.io/$IMAGE_NAME:$IMAGE_VERSION'
            }
        }
        stage('push image'){
            steps{
                sh 'sudo docker push ghcr.io/$IMAGE_NAME:$IMAGE_VERSION'
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
	     def userInput = false
           script {
             def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
             echo 'userInput: ' + userInput
             if(userInput == true) {
                echo "Start deploying"
            } else {
                echo "Action was aborted."
            }

        }
      }		
	else if ("${BranchName}" == 'test-dev') {
	    echo "Deploy to test"
		sh 'envsubst < $WORKSPACE/k8s/app_dep.yaml | kubectl apply -f - '
	}

}