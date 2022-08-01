pipeline{
    agent any

    environment{
        REGISTRY = ".dkr.ecr.us-east-1.amazonaws.com/aline-banking-bank-dh"
    }

    stages{

        stage('SonarQube Analysis') {
            steps{
                script{
                    def mvn = tool 'Default Maven';
                    withSonarQubeEnv() {
                        sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=jenkins"
                    }
                }
            } 
        }

        stage("Quality gate") {
            steps {
                withSonarQubeEnv('SonarScanner') {
                    waitForQualityGate abortPipeline: true
                }
            }
        } 

        stage('Build Image') {
            steps{ 
                echo 'Building Jar file'
                withMaven{
                    sh 'mvn --version'
                    sh 'mvn clean package -DskipTests'
                }
               
                script {
                    
                    dockerImage = docker.build(ACCOUNT+REGISTRY+':latest')
                    
                }
                
            }
        }
        stage('Deploy to ECR'){
            steps{
               echo 'Building and Deploying image to ECR registry'
               script{
                        docker.withRegistry('https://' + ACCOUNT + REGISTRY,'ecr:us-east-1:aws-cred-dh'){
                            dockerImage.push()
                        }
                }
                
            }
        }

    }
}
