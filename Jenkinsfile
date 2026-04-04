pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t my-first-app:${BUILD_NUMBER} .
                docker push valdevops7/my-first-app:${BUILD_NUMBER}
                '''
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