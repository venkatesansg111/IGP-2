pipeline {
    agent any

    tools {
        maven 'Maven3'       // Maven configured in Global Tool Configuration
    }

    environment {
        DOCKER_HOST = 'tcp://192.168.1.14:2375'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        IMAGE_NAME = "venkatesansg111/abctechnologies"
        CONTAINER_NAME = 'abctechnologies-container'
        SERVICE_NAME = 'abctechnologies-service'
        GIT_REPO = 'https://github.com/venkatesansg111/ABC_Project.git'
        BRANCH = 'main'
    }
    stages {
        stage('Code Checkout') {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }
        stage('Code Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Code Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Code Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Check Directory') {
            steps {
                sh 'pwd'
                sh 'ls -l'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker version'
                sh 'cp target/ABCtechnologies-1.0.war .'  
                sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."  
            }
        }
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-registry-credentials', url: '']) {
                    sh """
                        docker tag ${IMAGE_NAME}:${env.BUILD_NUMBER} ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:${env.BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }
        stage('Deploy Docker Image to Kubernetes with Ansible') {
            steps {
                sh """
                        whoami
                        env
                        ansible --version
                        ansible-playbook -i ansible/inventory.ini ansible/ping_test.yml
                        ansible-playbook -i ansible/inventory.ini ansible/deploy_k8s.yml
                    """
            }
        }
        stage('Archive WAR') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }
    }
}