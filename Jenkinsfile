pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose environment')
    }

    environment {
        IMAGE_NAME = "valdevops7/my-first-app"
        DEPLOYMENT_NAME = "my-app"
        CONTAINER_NAME = "my-container"
    }

    stages {

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    docker build -t \$IMAGE_NAME:\$BUILD_NUMBER .
                    docker push \$IMAGE_NAME:\$BUILD_NUMBER
                    """
                }
            }
        }

        stage('Deploy to Dev (Auto)') {
            when {
                expression { return params.ENV == 'dev' }
            }
            steps {
                sh """
                kubectl set image deployment/dev-\$DEPLOYMENT_NAME \
                \$CONTAINER_NAME=\$IMAGE_NAME:\$BUILD_NUMBER
                """
            }
        }

        stage('Approval for Prod') {
            when {
                expression { return params.ENV == 'dev' }
            }
            steps {
                input message: "Deploy to Production?"
            }
        }

        stage('Deploy to Prod') {
            when {
                expression { return params.ENV == 'prod' || params.ENV == 'dev' }
            }
            steps {
                sh """
                kubectl set image deployment/prod-\$DEPLOYMENT_NAME \
                \$CONTAINER_NAME=\$IMAGE_NAME:\$BUILD_NUMBER
                """
            }
        }

    }
}
