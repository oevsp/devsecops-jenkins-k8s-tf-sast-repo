pipeline {
  agent any
  tools { 
        maven 'Maven_3_5_2'  
    }
   stages{
    stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=vulnerable-web-app -Dsonar.organization=vulnerable-web-app -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=54e9ca427786cd9f55f464e6ef02e47dbb92a6e0'
			}
        } 
	  
	   stage('RunSCAAnalysisUsingSnyk') {
		   steps {
			   withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
				   sh 'mvn snyk:test -fn'
			   }
		   }
	   }

       stage('Build') {
        step {
            withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
                script {
                    app = docker.build("karol")
                }
            }
        }
    }

        stage('Push') {
            steps {
                script {
                    docker.withRegistry('AWS ECR URL', 'ecr:us-west-2:aws-credentials') {
                        app.push("latest")
                    }
                }
            }
        }
   }
  }
