pipeline{
    agent any
    stages{
        stage('Get repository'){
            steps{
                
            git([url: 'https://github.com/FourSeasons-Smoothstack/aline-bank-microservice-dh.git', branch: 'main'])
            }
        }
        stage('Build Jar') {
            steps{ 
                echo 'Building Jar file'
                
                sh 'mvn clean package -DskipTests'
                
                
            }
        }

        stage('Build and Deploy to ECR'){
            steps{
               echo 'Building and Deploying image to ECR registry'
               script{
                   docker.withRegistry('https://032797834308.dkr.ecr.us-east-1.amazonaws.com/aline-banking-dh', 'ecr:us-east-1:367a9760-4cd2-457e-8620-2ff4cfb8f79c')
                   {
                       def newApp = docker.build("032797834308.dkr.ecr.us-east-1.amazonaws.com/aline-banking-dh:aline-bank")
                       newApp.push()
                   }
                   
               }
            }
        }
    }
}

