pipeline {
    agent any
    options {timestamps ()}
    environment {
        GITHUB_TOKEN=credentials('github-token')
        IMAGE_NAME='lek-x/app'
        IMAGE_VERSION='1.0-b'
    }
    stages {
        stage('Checkout') {
            steps {checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '9f93b5c6-dd61-4259-9fc8-164b7f4318f3', url: 'git@github.com:lek-x/app.git']]])
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
            
        }
    post {
        always {
            sh 'sudo docker logout'
        }
    }
}