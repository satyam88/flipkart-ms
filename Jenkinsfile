pipeline {
    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }

    agent any

    tools {
        maven 'maven_3.9.4'
    }

    stages {
        stage('Code Compilation') {
            steps {
                echo 'Code Compilation is In Progress!'
                sh 'mvn clean compile'
                echo 'Code Compilation is Completed Successfully!'
            }
        }
        stage('Code QA Execution') {
            steps {
                echo 'Junit Test case check in Progress!'
                sh 'mvn clean test'
                echo 'Junit Test case check Completed!'
            }
        }
        stage('Sonarqube') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                    sh 'mvn sonar:sonar'
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Code Package') {
            steps {
                echo 'Creating War Artifact'
                sh 'mvn clean package'
                echo 'Creating War Artifact done'
            }
        }
        stage('Building & Tag Docker Image') {
            steps {
                echo 'Starting Building Docker Image'
                sh "docker build -t satyam88/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER} ."
                sh "docker build -t flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER} ."
                echo 'Completed Building Docker Image'
            }
        }
        stage('Docker Image Scanning') {
            steps {
                echo 'Docker Image Scanning Started'
                sh 'java -version'
                echo 'Docker Image Scanning Started'
            }
        }
        stage('Docker push to Docker Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubCred', variable: 'dockerhubCred')]) {
                        sh "docker login docker.io -u satyam88 -p ${dockerhubCred}"
                        echo "Push Docker Image to DockerHub: In Progress"
                        sh "docker push satyam88/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER}"
                        echo "Push Docker Image to DockerHub: Completed"
                    }
                }
            }
        }
        stage('Docker Image Push to Amazon ECR') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'ecr:ap-south-1:ecr-credentials', url: "https://559220132560.dkr.ecr.ap-south-1.amazonaws.com"]) {
                        sh """
                        echo "Tagging the Docker Image: In Progress"
                        docker tag flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER} 559220132560.dkr.ecr.ap-south-1.amazonaws.com/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER}
                        echo "Tagging the Docker Image: Completed"
                        echo "Push Docker Image to ECR: In Progress"
                        docker push 559220132560.dkr.ecr.ap-south-1.amazonaws.com/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER}
                        echo "Push Docker Image to ECR: Completed"
                        """
                    }
                }
            }
        }/*
        stage('Upload the docker Image to Nexus') {
          steps {
              script {
                 withCredentials([usernamePassword(credentialsId: 'nexuscred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                 sh 'docker login http://65.0.104.33:8085/repository/flipkart-ms/ -u admin -p ${PASSWORD}'
                 echo "Push Docker Image to Nexus : In Progress"
                 sh 'docker tag flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER} 65.0.104.33:8085/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER}'
                 sh 'docker push 65.0.104.33:8085/flipkart-ms:dev-flipkart-ms-v1.${BUILD_NUMBER}'
                 echo "Push Docker Image to Nexus : Completed"
                }
              }
           }
        }*/
	}
}