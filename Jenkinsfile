pipeline {
    agent {
  label 'GR1'
}   
environment {
    DOCKER_CREDS = credentials('dockerhub_id')
}
    stages {
        stage("SCM Checkout of maven project from GitHub"){
            steps {
            git credentialsId: 'a026967c-d847-44c6-8a86-fc99ff4efe00', url: 'https://github.com/tushartgupta/SampleMaven'
            
            }
            }
        stage ('Run ansible playbook to install docker, docker-compose and maven') {
            steps {
                sh 'ansible-playbook docker_install.yml' 
            }
        }
         stage ('Initialize the maven environment variables') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build the maven project') {
            steps {
                sh 'mvn clean package' 
            }
        }
           stage ('Docker Image build and deploy to Docker Hub') {
            steps {
                sh '''
                    docker login --username ${DOCKER_CREDS_USR} --password ${DOCKER_CREDS_PSW}
                    docker info
                    docker build -t tushargupta/tomcat_maven_jenkins:${BUILD_NUMBER} .
                    docker push tushargupta/tomcat_maven_jenkins:${BUILD_NUMBER}
                    docker image rm tushargupta/tomcat_maven_jenkins:${BUILD_NUMBER}
                '''
            }
        }
        stage ('Docker container run') {
            steps {
                sh '''
                    docker rm -vf $(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
                    docker images -a | grep "tushargupta" | awk '{print $3}' | xargs docker rmi 2>/dev/null || echo "No more images to remove"
                    docker run -d -p 9090:8080 tushargupta/tomcat_maven_jenkins:${BUILD_NUMBER}
                '''
            }
        }
    }
}
