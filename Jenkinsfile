pipeline {
    agent {
        kubernetes {
            cloud 'epyc'
            serviceAccount 'jenkins'
        }
    }

    stages {
        stage('dummy') {
            steps {
                script {
                    sh 'docker build -f 2web/Dockerfile -t epyc.2i.at:18444/2web:1.0'
                    sh 'docker push epyc.2i.at:18444/2web:1.0'
                    }
                }
            }
        }
    }