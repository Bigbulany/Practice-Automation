pipeline {
    agent any

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Choose environment')
    }

    environment {
        IMAGE_NAME = "valdevops7/my-first-app"
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

        stage('Deploy to Dev') {
            when {
                expression { params.ENV == 'dev' }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh """
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    cd terraform-k8s
                    terraform init
                    terraform apply -auto-approve \
                    -var="dev_image=\$IMAGE_NAME:\$BUILD_NUMBER" \
                    -var="prod_image=\$IMAGE_NAME:\$BUILD_NUMBER"
                    """
                }
            }
        }

        stage('Approval for Prod') {
            when {
                expression { params.ENV == 'dev' }
            }
            steps {
                input message: "Deploy to Production?"
            }
        }

        stage('Deploy to Prod') {
            when {
                expression { params.ENV == 'prod' || params.ENV == 'dev' }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh """
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    cd terraform-k8s
                    terraform init
                    terraform apply -auto-approve \
                    -var="dev_image=\$IMAGE_NAME:\$BUILD_NUMBER" \
                    -var="prod_image=\$IMAGE_NAME:\$BUILD_NUMBER"
                    """
                }
            }
        }

    }
}

