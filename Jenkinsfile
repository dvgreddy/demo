pipeline {
    agent any
	
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-key')
	  }
	
    stages {
        stage('Git Checkout') {
            steps {
               git "https://github.com/dvgreddy/demo.git"
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform destroy -auto-appove=yes'
                }
            }
        }
    }
}
