# Multi-Webserver Setup with HTTPD/Apache

This Bash script project automates the installation and configuration of a website using the `httpd` (for CentOS) or `apache2` (for Ubuntu/Debian) server. It allows setting up multiple web servers (e.g., `web01`, `web02`, `web03`) by installing necessary packages, deploying website files, and managing web services remotely via SSH.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Pre-requisites](#pre-requisites)
- [How to Use](#how-to-use)
- [Directory Structure](#directory-structure)
- [Detailed Script Documentation](#detailed-script-documentation)
    - [Local Installation Script](#local-installation-script)
    - [Remote Execution Script](#remote-execution-script)
- [Security Considerations](#security-considerations)
- [License](#license)

## Project Overview

This project aims to automate the installation of HTTPD/Apache web servers, configure and deploy websites across multiple servers, and start/restart services. The website content is downloaded from a provided URL and deployed onto each web server.

### Example Scenario

You have a set of three web servers (`web01`, `web02`, `web03`), and you want to:

- Install web server packages (`httpd` or `apache2`).
- Download and extract website templates from [tooplate.com](https://www.tooplate.com).
- Copy the extracted website files to the web root directory (`/var/www/html`).
- Start and enable the web server services.
- Ensure the deployment is automated across multiple servers.

## Features

- Installs `httpd` or `apache2` web servers depending on the OS.
- Supports both CentOS and Ubuntu/Debian-based systems.
- Downloads a website template from a URL and extracts it into the web root directory.
- Starts, enables, and restarts the web server services automatically.
- Automates the deployment process across multiple servers using SSH.

## Pre-requisites

Before running this project, ensure the following:

- SSH key-based authentication is configured between your local machine and the remote servers (`web01`, `web02`, `web03`).
- Sudo privileges for the remote user without a password prompt (use `visudo` to configure).
- The remote servers should be accessible via a private IP (defined in the `remhost` file).
- Remote servers are either running CentOS, RHEL, Ubuntu, or Debian.

### Software Requirements

- Bash (for script execution)
- SSH client (`ssh`, `scp`)
- Web servers (httpd/apache2)
- Package managers (`yum`, `apt`)

## How to Use

1. **Clone the repository** to your local machine:
    
    bash
    
    Copy code
    
    `git clone https://github.com/your-username/multi-webserver-setup.git`
    
2. **Edit the script files:**
    
    - Update the `remhost` file to list all the remote server hostnames or IPs.
    - Set the required `URL` for the website template download and the `ARTNAME` (extracted directory name) in the script.
3. **Push and execute the scripts on remote servers:**
    
    bash
    
    Copy code
    
    `bash remote_script_push.sh`
    
4. The script will connect to each server, push the local web setup script, execute it, and clean up afterward.
    

## Directory Structure

bash

Copy code

`multi-webserver-setup/ │ ├── multioswebsetup.sh      # Script to install HTTPD and deploy website locally ├── remote_script_push.sh   # Script to push and execute the setup on remote servers ├── remhost                 # File containing the list of remote server IPs or hostnames └── README.md               # Project documentation`

## Detailed Script Documentation

### Local Installation Script

`multioswebsetup.sh` automates the installation of HTTPD or Apache2, downloads the website template, and deploys it. Below is a breakdown of the key components:

1. **Package Installation:**
    
    Depending on the OS, the script installs `httpd` (for CentOS) or `apache2` (for Ubuntu) using the respective package manager (`yum` or `apt`).
    
    bash
    
    Copy code
    
    `PACKAGE="httpd wget unzip epel-release" sudo yum install $PACKAGE -y > /dev/null`
    
2. **Service Management:**
    
    The script starts and enables the web server service, ensuring it runs on startup.
    
    bash
    
    Copy code
    
    `sudo systemctl start $SVC sudo systemctl enable $SVC`
    
3. **Website Download and Deployment:**
    
    The website is downloaded using `wget`, extracted with `unzip`, and its contents are copied to `/var/www/html`.
    
    bash
    
    Copy code
    
    `wget $URL unzip $ARTNAME.zip sudo cp -r $ARTNAME/* /var/www/html`
    
4. **Clean-up:**
    
    The script cleans up temporary files by removing the downloaded content after deployment.
    
    bash
    
    Copy code
    
    `rm -rf $TMPDIR`
    
5. **Web Server IP Output:**
    
    The script outputs the IP address of the server using `ip addr show`.
    
    bash
    
    Copy code
    
    `ip addr show | grep 192*`
    

### Remote Execution Script

`remote_script_push.sh` is used to deploy and execute the local installation script on multiple remote servers.

1. **Host Loop:**
    
    The script loops through each host listed in the `remhost` file, using SSH and SCP to push and execute the installation script.
    
    bash
    
    Copy code
    
    `` for host in `cat remhost` ``
    
2. **Pushing the Script:**
    
    The `scp` command pushes the installation script to the remote server:
    
    bash
    
    Copy code
    
    `scp multioswebsetup.sh $USR@$host:/tmp/`
    
3. **Executing the Script Remotely:**
    
    Using `ssh`, the script is executed on the remote server with `sudo` permissions:
    
    bash
    
    Copy code
    
    `ssh $USR@$host sudo /tmp/multioswebsetup.sh`
    
4. **Clean-up:**
    
    After the script execution, the script file is removed from the remote server.
    
    bash
    
    Copy code
    
    `ssh $USR@$host sudo rm -rf /tmp/multioswebsetup.sh`
    

## Security Considerations

- Ensure SSH key-based authentication is secure and that sudoers privileges are properly configured for the remote user to avoid unauthorized access.
- Always verify the downloaded content from external websites (such as templates from tooplate.com) to avoid introducing vulnerabilities.
