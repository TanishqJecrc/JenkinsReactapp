pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'reactapptanishq'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/TanishqJecrc/JenkinsReactapp.git'
            }
        }

    stage('Terraform Init') {
                steps {
                    dir('Terraform') {
                        bat 'terraform init'
                    }
                }
          }
          stage('Terraform Plan & Apply') {
            steps {
                dir('Terraform') {
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

    
    stage('Setup Node Environment') {
            steps {
                dir('reactapp') {
                    bat 'node -v'
                    bat 'npm -v'
                    bat 'npm install -g npm@latest'
                }
            }
        }

        
        stage('Clean & Install Dependencies') {
            steps {
                dir('reactapp') {
                    bat 'del package-lock.json' // Clean previous installs
                    bat 'npm install || echo "Retrying npm install..." && npm install' // Retry if fails
                    
                }
            }
        }
        
        stage('ReactBuild') {
            steps {
                dir('reactapp') {
                    bat 'npm run build' // Build the React app
                    bat 'powershell Compress-Archive -Path ./build/* -DestinationPath build.zip' // Archive build output
                }
                
            }
        }
         
        stage('Deploy') {
            steps {
               dir('reactapp') {
                    withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat "az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID"
                   
                    bat "az staticwebapp upload --name $APP_SERVICE_NAME --resource-group $RESOURCE_GROUP --source ./build.zip"
                }
                }
                   
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
            
        }
    }
}