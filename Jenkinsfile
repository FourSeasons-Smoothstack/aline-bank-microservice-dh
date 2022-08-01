pipeline{
    agent any

    tools {
        maven "Default Maven"
        dockerTool "Default Docker"
    }

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
                withMaven(maven: 'Default Maven'){
                    
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
        stage('Upload image to K8 cluster'){
            steps{
                echo 'Updating image file on cluster with newly built image.'
                sh "export AWS_DEFAULT_REGION=us-east-1"

                script{
                    withAWS(credentials: 'aws-cred-dh', region: 'us-west-1'){
                        sh "kubectl set image deployment/aline-bank aline-bank=032797834308.dkr.ecr.us-east-1.amazonaws.com/aline-banking-bank-dh:latest"
                    }
                }
                
                

            }
        }

    }
}
