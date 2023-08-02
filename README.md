# App-Deploy

Title: Streamlining Java Web Application Deployment with Jenkins Master-Slave Architecture: A CI/CD Pipeline Guide.

Description:

In today's fast-paced software development landscape, automating the build and deployment process is crucial to achieve faster and error-free software delivery. 
In this blog post, we'll explore how to leverage Jenkins, GitHub, Maven, and Tomcat to create a robust CI/CD pipeline for your Java web application. 
What's more, we'll take advantage of Jenkins' master-slave architecture to distribute the workload efficiently and optimize your development workflow.

Introduction:

Introducing automation to your Java web application's build and deployment process can significantly improve productivity and quality. 
This blog post is your step-by-step guide to setting up a seamless CI/CD pipeline using Jenkins master-slave architecture, GitHub for version control, 
Maven for building, and Tomcat for deploying your .war files.

Section 1: Preparing the Infrastructure
Before diving into the technical details, we'll cover the prerequisites for setting up Jenkins, the master-slave architecture, and ensuring smooth communication 
between Jenkins and GitHub.

Section 2: Integrating GitHub for Version Control
A solid CI/CD pipeline relies on a version control system like GitHub. We'll guide you through integrating your GitHub repository with Jenkins.

Section 3: Creating a Jenkins Pipeline Script
Creating a Jenkins Pipeline script involves defining the steps of your CI/CD (Continuous Integration/Continuous Deployment) process in a script format. 
Jenkins Pipeline is a powerful way to automate building, testing, and deploying code in Jenkins.

Section 4: Creating a new pipeline Job


By the end of this blog post, you'll have a comprehensive understanding of how to create a streamlined and efficient CI/CD pipeline for your Java web application 
using Jenkins master-slave architecture. Embracing automation and best practices will not only enhance your development team's productivity but also lead to more 
reliable and faster software releases. Let's unlock the full potential of Jenkins, GitHub, Maven, and Tomcat to revolutionize your Java web application development 
workflow.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Section 1: Preparing the Infrastructure

Setting up a robust CI/CD pipeline requires a well-prepared infrastructure. In this section, we'll guide you through the essential steps to prepare your environment 
for Jenkins, master-slave architecture, and seamless integration with GitHub. Let's get started!

1. Setting up Jenkins:

Setting up Jenkins is the first crucial step in establishing your CI/CD pipeline. We'll guide you through the installation process for deploying Jenkins on a 
cloud-based server (AWS EC2 instance in particular) and ensure that your Jenkins instance is secure with proper authentication and authorization. 
Let's get started with the setup:

Link: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
 
2. Install Git on the same server.

For version control, we'll use Git, a popular distributed version control system.
For installing Git ref:

Commands:
	sudo yum update
	sudo yum install git

3. Jenkins Master-Slave Setup.

Setting up a Jenkins master-slave architecture allows you to distribute the build workload across multiple nodes, providing better performance and scalability. 
The master is responsible for managing the Jenkins system and coordinating tasks, while the slaves are responsible for executing build jobs.

Below are the steps to set up a Jenkins master-slave architecture:

Step 1: Configure Jenkins Master.

- Access the Jenkins web interface using your browser by entering the URL of your Jenkins server (e.g., http://your-jenkins-server:8080).
- Complete the initial Jenkins setup by providing the administrator password and installing the recommended plugins.
- Set up an admin user account for managing Jenkins.

Step 2: Create an EC2 instance for Jenkins Slave and install Java 11 and Git.
- Launch an EC2 instance on AWS, ensuring it is in the same VPC (Virtual Private Cloud) as the Jenkins Master.
- During instance setup, choose an appropriate Amazon Machine Image (AMI) that has Java 11 installed (e.g., Amazon Linux 2 or Ubuntu with OpenJDK 11).
- Follow the usual steps to set up the instance, including selecting the security group, key pair, and storage.
- Once the instance is running, note down its public IP address.

Step 3: Create a Directory in the user's home directory on the Jenkins Slave.
- After logging into the Jenkins Slave EC2 instance, create a directory dedicated to Jenkins. For example, you can use the following command:

  mkdir /home/ec2-user/jenkins

Step 4: Establish an SSH connection between Jenkins Master and Slave.
- Open a terminal or command prompt on the Jenkins Master machine.
- Use the SSH key pair you already have or generate a new SSH key pair using the `ssh-keygen` command.
- Once you have the key pair, copy the public key from the master to the authorized_keys of slave directly.

Then use the command "ssh ec2-user@public_IP_of_Slave

Step 5: Add the credentials to connect to the slave machine.
- In the Jenkins dashboard, click on "Manage Jenkins" in the left-hand sidebar.
- Select "Manage Credentials."
- Click on "Global" domain.
- Click on "Add Credentials" on the Right sidebar.
- Fill in the following details:
  - Kind: SSH Username with private key
  - Scope: Global
  - Username: ec2-user
  - Private Key: Enter the private key content directly (you can copy the content from `~/.ssh/id_rsa` on the Jenkins Master machine).
  - ID: Create a unique ID to identify these credentials (e.g., "jenkins-slave-ssh-credentials")
  - Description: Provide a description for these credentials if needed.
- Click on "OK" to save the credentials.

Step 6: Add an Agent.
- In the Jenkins dashboard, click on "Manage Jenkins" in the left-hand sidebar.
- Select "Manage Nodes and Clouds."
- Click on "New Node" to create a new slave node.
- Select Permanent Agent and then click on Create
- Fill in the following details:
  - Node Name: Choose a name for the slave node.
  - Usage: Select "Use this node as much as possible."
  - Remote root directory: Specify the path of the directory dedicated to Jenkins on the slave server (e.g., `/home/ec2-user/jenkins`).
  - Labels: Optionally, you can assign labels to the slave node for specific job assignments.
  - Launch method: Select "Launch agent via SSH."
  - Host: Enter the public IP address of the Jenkins Slave machine.
  - Credentials: Select the credentials you created in Step 4 from the dropdown.
  - Host Key Verification Strategy: Choose "Known hosts file Verification Strategy" or "Non Verifying Verification Strategy" based on your preference.
  - Availability: Select "Keep this agent online as much as possible."
  - Node Properties: Leave this section blank.
- Click on "Save" to create the Jenkins Slave node.

Now, Jenkins should be able to connect to the Slave using SSH and utilize it as an agent for running builds and jobs.

step 7. Install Maven on Slave Server.

Maven is a powerful build automation tool for Java projects.
For installation : ref: https://devopscube.com/install-maven-guide/
In the above link, after the installation of openJDK, the link to install the Maven did not work for version 3.9.0. So I used the latest version 
 wget https://apache.osuosl.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.tar.gz
Later in the subsequest commands, replaced the version from 3.9.0 to 3.9.3. Only this needs to be changed, rest all worked good. 

step 8. Set up a Tomcat Server.

The end goal of our pipeline is to deploy your Java web application on a Tomcat server.
For installation : ref : https://medium.com/@raguyazhin/step-by-step-guide-to-install-apache-tomcat-on-amazon-linux-120748a151a9

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Section 2: Integrating GitHub for Version Control

In this section, we'll focus on the essential step of integrating GitHub with Jenkins, establishing a seamless connection between your version control system and the 
CI/CD pipeline. By setting up this integration, you'll enable automated builds triggered by code commits, ensuring that your pipeline stays up-to-date with the 
latest changes in your Java web application.

1. Jenkins GitHub Plugin:

Jenkins provides a dedicated GitHub plugin that simplifies the integration process and enable seamless communication between Jenkins and your GitHub repository.

Under Section-2

2. Setting Up Credentials:

To access your GitHub repository securely, you'll need to provide Jenkins with appropriate credentials.

To generate personal access tokens in GitHub and add them as credentials in Jenkins, follow these steps:

1. Generating Personal Access Tokens in GitHub:
   - Log in to your GitHub account.
   - Click on your profile picture in the top right corner and go to "Settings."
   - In the left sidebar, click on "Developer settings," and then click on "Personal access tokens, Here Select Tokens(classic)
   - Click on "Generate new token" and follow the instructions to set the token's permissions and expiration.
   - After generating the token, copy and save it immediately as you won't be able to see it again.

2. Adding Credentials in Jenkins:
   - Open Jenkins and log in with appropriate credentials.
   - On the Jenkins dashboard, click on "Manage Jenkins" in the left sidebar.
   - Then, click on "Manage Credentials."
   - Click on "Global" domain (or an appropriate domain) and then "Add Credentials" from the left sidebar.
   - Choose the appropriate credential type:
     - Select Kind as Username with passsword
     - Scope : Global
     - Username : Enter your Github account Username
     - Password : Enter the Personal Access Token generated in the previous step.
     - Enter a unique ID for the credentials.
     - Optionally, provide a description for the token.
   - Click on "OK" to save the credentials.

Now, you have added the necessary credentials in Jenkins, and you can use them in your Jenkins jobs or pipelines to interact with your GitHub repositories securely.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Section 3: Write a Jenkins pipeline script to build and deploy a JAVA web application.

a. On Github, Fork this repository (https://github.com/bprasad701/App-Deploy.git).
b. On Jenkins-Master, Clone the Repository from Github. 

   $git clone https://github.com/your_user_name/App-Deploy.git

c. Add the below pipeline script to "Jenkinsfile" in the Repo and commit the changes and push it to remote repo hosted on github.

Pipeline Script:

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
                sh "curl -v -u ${env.TOMCAT_USER}:${env.TOMCAT_PASSWORD} -T ./target/*.war ${env.TOMCAT_URL}/manager/text/deploy?path=/obs&update=true"    
                // Note that the "/manager/text" endpoint requires proper Tomcat Manager credentials, which we will set up later.
            }
        }
    }
        
    
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Section 4: Create a new Pipeline Job on Jenkins Dashboard.

Step 1: Create a new Pipeline Job:

- From the Jenkins dashboard, click on "New Item" to create a new job.
- Enter a name for the job (e.g., "GitHub Pipeline").
- Select "Pipeline" as the project type and click on "OK."

Step 2: Configure the Pipeline Job:

- In the "Pipeline" section, select "Pipeline script from SCM" as the Definition.
- Choose "Git" as the SCM (Source Code Management).
- Provide the URL of the GitHub repository where your pipeline script is hosted.
- Under "Credentials," select the GitHub credentials you created in Section 2.
- In "Branch Specifier," specify the branch of the repository where your pipeline script is located (e.g., "main" or "master").
- Optionally, you can set up a polling schedule to trigger the job automatically whenever changes are pushed to the repository.
- Click on "Save" to save the job configuration.

Step 3: Run the Pipeline Job:

- Go back to the Jenkins dashboard and click on the name of your Pipeline Job.
- Click on "Build Now" to start the pipeline job.
- Jenkins will clone the GitHub repository, retrieve the "Jenkinsfile," and execute the pipeline steps defined in the script.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

In summary, this pipeline script will clone the Git repository, build the Maven project, archive the WAR artifact, and deploy the generated WAR file to the specified 
Tomcat server using the Tomcat Manager API. The script uses the provided Tomcat Manager credentials (TOMCAT_USER and TOMCAT_PASSWORD) to authenticate the deployment 
request.

