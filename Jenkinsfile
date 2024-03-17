pipeline {
    agent any

    environment {
        // Update these variables with your actual information
        DOCKER_IMAGE = 'dunkdock/user-form' // Replace with your Docker image name
        DOCKER_TAG = 'latest' // Using the latest tag or you can use ${env.BUILD_ID} for unique tagging
        DOCKERFILE_PATH = 'Dockerfile' // Path to Dockerfile in your GitHub repository
        DEPLOYMENT_YAML_PATH = 'deployment.yaml' // Path to your Kubernetes deployment file in the repo
        SERVICE_YAML_PATH = 'service.yaml' // Path to your Kubernetes service file in the repo
        DOCKER_REGISTRY_URL = 'https://index.docker.io/v1/' // Your Docker registry URL
        DOCKER_CREDENTIALS_ID = 'dunkdock' // The ID of your Docker credentials in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to registry
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        docker.withRegistry("${DOCKER_REGISTRY_URL}", 'DOCKER_USERNAME', 'DOCKER_PASSWORD') {
                            docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy the Kubernetes deployment and service
                    sh "kubectl apply -f ${DEPLOYMENT_YAML_PATH}"
                    sh "kubectl apply -f ${SERVICE_YAML_PATH}"
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
