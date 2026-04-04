pipeline {
    agent any

    stage('Build & Push Docker Image') {
        steps {
            withCredentials([usernamePassword(
                credentialsId: 'dockerhub-creds',
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS'
            )]) {
                sh """
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker build -t valdevops7/my-first-app:${BUILD_NUMBER} .
                docker push valdevops7/my-first-app:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                kubectl apply -f ingress.yaml
                kubectl set image deployment/my-app my-container=valdevops7/my-first-app:${BUILD_NUMBER}
                '''
            }
        }
    }
}