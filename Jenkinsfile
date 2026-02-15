pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = 'samagyasapkota/spring-app'
        KUBECONFIG = '/home/jenkins/.kube/config'
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
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
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sh "echo \$DOCKER_HUB_CREDENTIALS_PSW | docker login -u \$DOCKER_HUB_CREDENTIALS_USR --password-stdin"
                sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    for i in 1 2 3 4 5; do
                        curl -sk https://192.168.56.20:6443/healthz | grep -q ok && break
                        echo "Waiting for k8s API... attempt \$i"
                        sleep 15
                    done
                    kubectl set image deployment/petclinic-app \
                        springboot-petclinic=arey/springboot-petclinic:latest \
                        -n petclinic
                    echo "Image updated successfully"
                    sleep 30
                    kubectl get pods -n petclinic
                """
            }
        }
        stage('Scale to 5 Pods') {
            steps {
                sh """
                    kubectl scale deployment petclinic-app --replicas=5 -n petclinic
                    sleep 15
                    kubectl get pods -n petclinic
                """
            }
        }
    }
    post {
        success { echo 'Pipeline completed successfully!' }
        failure { echo 'Pipeline failed!' }
        always { sh 'docker logout || true' }
    }
}
