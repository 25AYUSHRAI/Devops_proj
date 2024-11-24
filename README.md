This is the project for the devops that contains the following question to solved .
 
Q1 . write shell script to install jenkins 

-Idependent of Operating System dependency 

- User must provide version to install

SCRIPT :+1:  
**************************************************************************************************************************
#!/bin/bash

#install Jenkins
function install_jenkins {
  #Update reps
  case "$OS" in
    "ubuntu"|"debian")
      sudo apt update -y
      sudo apt install -y wget gnupg
      wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
      echo "deb http://pkg.jenkins.io/debian/ stable main" | sudo tee /etc/apt/sources.list.d/jenkins.list
      sudo apt update -y
      sudo apt install -y jenkins
      ;;
    "centos"|"rhel"|"fedora")
      sudo yum install -y wget
      sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
      sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
      sudo yum install -y jenkins
      ;;
    "amazon linux")
      sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
      sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
      sudo yum install -y jenkins
      ;;
    *)
      echo "Unsupported OS: $OS"
      exit 1
      ;;
  esac
}

#install Java
function install_java {
  case "$OS" in
    "ubuntu"|"debian")
      sudo apt update -y
      sudo apt install -y openjdk-"$JAVA_VERSION"-jdk
      ;;
    "centos"|"rhel"|"fedora")
      sudo yum install -y java-"$JAVA_VERSION"-openjdk
      ;;
    "amazon linux")
      sudo yum install -y java-"$JAVA_VERSION"-openjdk
      ;;
    *)
      echo "Unsupported OS: $OS"
      exit 1
      ;;
  esac
}

#Check if provided argument
if [ $# -eq 0 ]; then
	echo "Specify java version and try egain"
	exit 1
fi

JAVA_VERSION="$1"

if [[ -z "$JAVA_VERSION" ]]; then
  echo "Java version must be specified."
fi

#get os
if [ -f /etc/os-release ]; then
  source /etc/os-release
  OS=$(echo $ID | tr '[:upper:]' '[:lower:]')
else
  echo "Unable to detect operating system."
  exit 1
fi

install_java
install_jenkins



************************************************************************************************************************
THE WORKFLOW OF THE ABOVE SCRIPT IS :--

#INSTALL JENKINS FUNCTION
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#INSTALL JAVA FUNCTION


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
* The second function is install_java which will install jdk for the follwing OS dependency same like installing jenkins functions . In scripting defining the function at the  start is important . As jenkins needs jdk11 version as the minimum requirement to run . Proving the user a option for installing there desired version .

*A variable name JAVA_VERSION which will get the version as the input . the function is defined with cases for OS dependency name ubuntu 0or debian the following code will run ->

  *" sudo apt update -y " -> This command will update the system if not .
      
  *" sudo apt install -y openjdk-"$JAVA_VERSION"-jdk " -> this command is used for installing jdk with the desired java version 
                                                          "$JAVA_VERSION" which uses the input value of the java version .
** THERE ARE TWO MORE IF CONDITIONS THAT CHECKS WHETHER 





























#!/bin/bash

#find files/directories with modify time(mtime) > 7 days and perform action delete
# $1 is path to directory to cleanup
function cleanup {
    find "$1" -mtime +7 -delete
}

#get source_path, des_path, exit staus of transfer(0 if success 1 if fail) then append into the /log.txt file
function log {
    echo "src: $1; des: $2; exit: $3 " >> /log.txt
}

#chk if atleast 2 args passed and not more than 3 passed
# $# returns number of args passed
if [ $# -ge 1 ] && [ $# -le 3 ]; then
    # Check if source exists
    if ! [ -e "$1" ]; then
        echo "file: $1 does not exist"
        exit 1
    fi
    
    # set des file name; basename returns the last file name from the path string,  Ex: file1_22Nov2024
    # set destination file path in path variable
    bfile_name=$( basename "$1" )_$( date +"%d%b%Y" )
    path="$2/$bfile_name"

    # Make destination directory if not exist; use -p to make parent dir if needed and not throw errors
    mkdir -p "$2"

    # Compress and save to destination and exit with success status
    if [ "$3" != "1" ]; then
        # tar [options] [destination] [source]
        tar -czf "$path.tar.gz" "$1"
        log "$1" "$path" $?
        cleanup "$2"
        exit 0
    fi

    # Copy recursively files from source to destination
    cp -r "$1" "$path"
    log "$1" "$path" $?
    cleanup "$2"
    exit 0

#if invalid arguments passed
else
    echo "0 or too many arguments passed"
    exit 1
fi

*********************************************************************************************************************

