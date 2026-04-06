pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the environment to deploy to')
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
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                    docker push $IMAGE_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                kubectl set image deployment/$ENV-$DEPLOYMENT_NAME \
                $CONTAINER_NAME=$IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

    }
}