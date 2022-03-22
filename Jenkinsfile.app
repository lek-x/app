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
        IMAGE_VERSION="${BUILD_NUMBER}"
        BranchName = "${BRANCH_NAME}"
    }
    stages {
        stage('Debug ENVs') {
            steps {
                 echo "Branch name $BranchName"
				 echo "Build number is $IMAGE_NAME"
				 echo "Build number is $IMAGE_VERSION"
				 }
            } 
        stage('Linter checking'){
            steps{
                sh "cd ${WORKSPACE}"
                sh "pylint --py3k hello.py init_db.py"
                }
            }
        stage('Cleanup Docker elements'){
            steps{
                sh "sudo docker system prune -a --volumes --force"
            }
        }    
        stage('Build Docker image'){
            steps{
			    echo "Current build version is $IMAGE_NAME:$IMAGE_VERSION"
                sh "cd ${WORKSPACE}"
                sh "sudo docker build . -t $IMAGE_NAME:$IMAGE_VERSION"
                sh "sudo docker images"
            }    
        }
        stage('Checking Docker image by  Acnhore grype'){
            environment {
            iid = sh(returnStdout: true, returnStatus: false, script: 'sudo docker images -q $IMAGE_NAME').trim()
            }
            steps{
                echo "DEBUG ${env.iid}"
                sh "sudo grype ${env.iid} -f high"
            }
        }
        stage('Logging into Github registry'){
            steps{
                sh 'echo $GITHUB_TOKEN_PSW | sudo docker login ghcr.io -u $GITHUB_TOKEN_USR --password-stdin'
                
            }
        }
        stage('Tagging Docker image'){
            steps{
			     echo "Debug tag ${env.TG}"
                sh 'sudo docker tag $IMAGE_NAME:$IMAGE_VERSION ghcr.io/$IMAGE_NAME:$IMAGE_VERSION'
            }
        }
        stage('Pushing Docker image to registry'){
            steps{
                sh 'sudo docker push ghcr.io/$IMAGE_NAME:$IMAGE_VERSION'
            }
        }
        stage('Deploy New build if master'){
          when{environment name: 'BranchName', value: 'master'}
            steps{
              deploy('master')
             }
            }
        stage('Deploy New build test-dev'){
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
                sh 'sudo kubectl config use-context arn:aws:eks:eu-central-1:283243481187:cluster/mycluster-v2 \
                  && sudo kubectl set image deployment/myapp myapp=ghcr.io/$IMAGE_NAME:$IMAGE_VERSION'
            } else {
                echo "Action was aborted by user $BUILD_USER"
            }

        }
      }		
	else if ("${BranchName}" == 'test-dev') {
	    echo "Deploy to test"
		sh 'kubectl set image deployment/myapp myapp=ghcr.io/$IMAGE_NAME:$IMAGE_VERSION' 
	}

}