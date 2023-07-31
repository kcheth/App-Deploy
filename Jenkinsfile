pipeline {
    agent any
    environment {
        // Customize these variables based on your setup
        TOMCAT_URL = "http://15.206.210.193:8080"
        TOMCAT_USER = "admin"
        TOMCAT_PASSWORD = "admin"
        REPO_URL = "https://github.com/bprasad701/App-Deploy.git"
    }

    stages {
        stage("git_checkout") {
            steps {
                git branch: 'main', credentialsId: 'githubloginID', url: "${REPO_URL}"
                echo "Repo cloned successfully"
            }
        }

        stage("Build") {
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo "Archiving the artifact"
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                // This step will deploy the generated artifact (e.g., WAR file) to Tomcat
                sh "curl -v -u ${env.TOMCAT_USER}:${env.TOMCAT_PASSWORD} -T **/target/*.war ${env.TOMCAT_URL}/manager/text/deploy?path=/obs&update=true"    
                // Note that the "/manager/text" endpoint requires proper Tomcat Manager credentials, which we will set up later.
            }
        }
    }
        
    
}

