This is the project for the devops that contains the following question to solved .
 
 # Q1 .
write shell script to install jenkins 

-Idependent of Operating System dependency 

- User must provide version to install

SCRIPT :+1:  
**************************************************************************************************************************
The file name ./jenkins_inst.sh 
************************************************************************************************************************
THE WORKFLOW OF THE JENKINS ISNTALL SCRIPT IS :--
# INSTALL JENKINS FUNCTION

* The script start with the first function name install_jenkins . Which get the input of the Operating System as the input . According to the input of the variable name OS case are defined . The cases contains the commands lines for the each of the OS . Starting with the  ubuntu or debian . Which has all the commands stating from :--
*  "sudo apt update -y" ->which updates the system .
 
*  "sudo apt install -y wget gnupg"->this is the command line for installing the wget package installer fro the ubuntu operating system . in case if the user did't install the package installer .

* "wget -q -O - https://pkg.jenkins.io/jenkins.io.key"->

Downloads the GPG key for the Jenkins repository.
 #This key is used to verify the authenticity of the packages from the repository.

* "sudo tee /etc/apt/trusted.gpg.d/jenkins.asc"->

   1. Adds the downloaded GPG key to the trusted keys directory for APT (/etc/apt/trusted.gpg.d).
   2. This ensures that the packages from the Jenkins repository are trusted by your system.

* "echo "deb http://pkg.jenkins.io/debian/ stable main"->

    1.Specifies the Jenkins APT repository as a package source.
    2.The URL http://pkg.jenkins.io/debian/ is the location of the Jenkins package files.
    3.The stable main section indicates you're using the stable release of Jenkins.
* "sudo tee /etc/apt/sources.list.d/jenkins.list " ->

   1.Saves the repository information (deb ...) to a file named jenkins.list in the APT sources directory (/etc/apt/sources.list.d).
   2.This makes the Jenkins repository available for package management with apt.

** "sudo apt install -y jenkins"-> 
   
   1.This command is used for setting up the installation of the jenkins on the system .
   2.after this the jenkins is successfully installed in the system of the  ubuntu .

THE COMMANDS FOR THE UBUNTU IS NOW COMPLETE THEN THERE ARE THE COMMANDS FOR THE "centos"|"rhel"|"fedora"  . THEN COMMANDS WILL RUN FROM THE TOP TO BOTTOM FOR THE FOLLOWING TO SAME LIKE THE UBUNTU . AS THERE ARE MANY OPERATING SYSTEM LIKE WINDOWS , MACos, etc . THE SAME OPTIONS WILL DEFINED FOR THE THEM TO . THE SCRIPT IS NOT FULLY OS INDEPENDENT BUT PARTIALLY .

# INSTALL JAVA FUNCTION

* The second function is install_java which will install jdk for the follwing OS dependency same like installing jenkins functions . In scripting defining the function at the  start is important . As jenkins needs jdk11 version as the minimum requirement to run . Proving the user a option for installing there desired version .

*A variable name JAVA_VERSION which will get the version as the input . the function is defined with cases for OS dependency name ubuntu 0or debian the following code will run ->

  *" sudo apt update -y " -> This command will update the system if not .
      
  *" sudo apt install -y openjdk-"$JAVA_VERSION"-jdk " -> this command is used for installing jdk with the desired java version 
                                                          "$JAVA_VERSION" which uses the input value of the java version .
** THERE ARE TWO MORE IF CONDITIONS THAT CHECKS INPUT IS  GIVEN BY THE USER OR NOT WHERE AS THE OTHER CHECK WHEHTER THE JAVA_VERSION IS TAKEN AS THE INPUT OR NOT .



# GET OS 

then there is a condition to find the OS of the system . on which is going to be installed .

# FUNCTION IS CALLED 
 the function is called in the order first the java is installed where then intall jenkins function is called . which will automatically install the java and jenkins in the system .
On running the script on the system it will automatically install the java and jenkins on the system 

# Q2 . 
Setup Master-slave architecture 
It should be capable of executing 5 tasks at a time 
# Master Slave
 Steps to Set Up a Master-Slave Configuration in Jenkins Using the GUI (Slave in AWS VPC):
 
Step 1: Set Up the Jenkins Master
Install the Required Plugins:
Go to Manage Jenkins > Manage Plugins.
In the Available Plugins tab, search for and install the "SSH Build Agents" plugin.
Generate an SSH Key on the Master:Step 2: Prepare the AWS Slave
Launch an EC2 instance in the AWS VPC with an Amazon Linux or Ubuntu AMI.
Ensure the security group allows SSH access from the Jenkins master.
Install Java on the EC2 instance (matching the Jenkins master version).
Add the Jenkins master's public SSH key to the EC2 instance's authorized keys for passwordless access.

Generate an SSH key pair on the Jenkins server:
bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/jenkins_slave_key
Save the private key for later. Copy the public key to use on the AWS slave instance.

Step 2: Prepare the AWS Slave
Launch an EC2 instance in the AWS VPC with an Amazon Linux or Ubuntu AMI.
Ensure the security group allows SSH access from the Jenkins master.
Install Java on the EC2 instance (matching the Jenkins master version).
Add the Jenkins master's public SSH key to the EC2 instance's authorized keys for passwordless access.

Step 3: Add the Slave in the Jenkins GUI
Access the Jenkins Dashboard:

Log in to Jenkins and navigate to the main dashboard.
Add a New Node:

Go to Manage Jenkins > Manage Nodes and Clouds > New Node.
Provide a Node Name (e.g., AWS-Slave) and select Permanent Agent.
Click OK.
Configure the Node:

Fill in the following details:
Remote Root Directory: /home/ec2-user/jenkins_slave (or another directory on the AWS slave).
Labels: Add labels like aws or slave for job assignment.
Usage: Choose Use this node as much as possible or Only build jobs with label expressions.
Launch Method:

Select Launch agents via SSH.
Provide the following:
Host: Public or private IP address of the AWS instance.
Credentials:
Click Add > Jenkins.
Select SSH Username with Private Key.
Enter:
Username: ec2-user (or the appropriate user for the AWS instance).
Private Key: Paste the private key generated on the master (~/.ssh/jenkins_slave_key).
Save Configuration:

Save the node configuration.

Step 4: Verify the Slave Connection
Check Node Status:

Go to Manage Nodes and Clouds.
Ensure the status of the new node is Online.
Test Job Execution:

Create a new job or edit an existing one.
Under the Build Environment section, set the Restrict where this project can be run option and use the label assigned to the slave (e.g., aws).

Step 5: Security Best Practices
Restrict Network access ,

Use a private IP address or VPN for communication between master and slave.
Limit the security group rules to allow only Jenkins master to connect to the slave.
Secure Jenkins with HTTPS:

Configure SSL for Jenkins to ensure secure communication.
This process sets up a Jenkins slave running in an AWS VPC entirely through the Jenkins GUI.

# Q3
Setup Role based authorization 
**************************************************************************************************

# Q4
 Create a pipeline to execute a shell script 

* on git 

* on scripting task 

* Monitor disk utlization and send mail if > 80% 

* Process Management

**********************************************************************************************************


# Q5 
create another shell script that automates the backup of important files and directories to a backup location. The script should: 

Take inputs: 

The source directory (which files and directories to back up). 

The destination directory (where the backup should be saved). 

An optional flag for compressing the backup into a .tar.gz file. 

Check for errors: 

Ensure that the source directory exists. 

Ensure that the destination directory exists (if it doesn't, the script should create it). 

Backup process: 

If the compress flag is provided, the backup should be a compressed .tar.gz archive. 

If the compress flag is not provided, the script should simply copy the files to the destination directory. 

Logging: 

Create a log file where the script writes the success or failure of each backup operation, along with a timestamp. 

Cleanup: 
If the backup was successful, remove any backups older than 7 days in the destination directory. 

 
