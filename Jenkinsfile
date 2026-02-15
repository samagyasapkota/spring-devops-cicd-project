pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = 'samagyasapkota/spring-app'
        KUBECONFIG = '/home/jenkins/.kube/config'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Maven') {
            steps {
                dir('JavaApp-CICD') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "echo \$DOCKER_HUB_CREDENTIALS_PSW | docker login -u \$DOCKER_HUB_CREDENTIALS_USR --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                retry(3) {
                    sh """
                        kubectl set image deployment/petclinic-app \
                            springboot-petclinic=${DOCKER_IMAGE}:${BUILD_NUMBER} \
                            -n petclinic
                        kubectl rollout status deployment/petclinic-app -n petclinic --timeout=120s
                    """
                }
            }
        }
        stage('Scale to 5 Pods') {
            steps {
                retry(3) {
                    sh 'kubectl scale deployment petclinic-app --replicas=5 -n petclinic'
                    sh 'kubectl get pods -n petclinic'
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            sh 'docker logout'
        }
    }
}
