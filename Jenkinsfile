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
  }
}
