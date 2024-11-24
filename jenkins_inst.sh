#!/bin/bash

#install Jenkins
function install_jenkins {
  # Update reps
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

#ins Java
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

# Check if provided argument
if [ $# -eq 0 ]; then
	echo "Specify java version and try egain"
	exit 1
fi

JAVA_VERSION="$1"

if [[ -z "$JAVA_VERSION" ]]; then
  echo "Java version must be specified."
fi

# get os
if [ -f /etc/os-release ]; then
  source /etc/os-release
  OS=$(echo $ID | tr '[:upper:]' '[:lower:]')
else
  echo "Unable to detect operating system."
  exit 1
fi


install_java
install_jenkins
