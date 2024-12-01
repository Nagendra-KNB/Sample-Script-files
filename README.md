## 28-10-2024
#
#Creating a MongoDB Container
#
# 1. update & upgrade the ubuntu
	I have updated the system with the command
	 ~ sudo apt update && sudo apt upgrade 
# 2. Installing Docker
	installed the docker software
	 ~ sudo apt install docker -y
# 3. Installed latest version of docker with the command

	~ curl -fsSL https://get.docker.com -o install-docker.sh
	~ sudo sh install-docker.sh
# 4. Pulled the image 'mongodb' from docker hub with the command
	~ sudo docker pull mongo

	~ sudo docker images  --------to check the basic info of existing images
# 5. Created a docker contsiner using 'mongo' image with the command
	~ sudo docker container run mongo
	
	~ sudo docker ps -a ---------to check details of the containers
# 6. Initializing the MongoDB server with the command 
 	~mongosh
  * Testing the database server with sample data
   
      test> use food
	switched to db food
      food > db.createCollection("fruits")
	{ ok: 1}
      food > db.fruits.insertMany([ {name:"apple", origin: "usa", price: 6} , {name: "orange", origin: "italy", price: 3} , {name: "mango", origin: "malaysia", price: 3} , {name:"pappaya", origin: "india", price: 6} ])

      food > db.fruits.find().pretty()
	-----displayed the data that we have inserted

#7. Stop the MongoDB server
 	~exit 
#############################################################################################################################################

## 29-10-2024
#
# Mount the containers 
  * Update the system
	~sudo apt update 
	~sudo apt upgrade
## Trouble shooting -----can't insert data in the database, install required dependencies that are causing the problem
 	~ sudo apt install libc6 libcurl4 libssl3
## Now install the Mongodb
	~ sudo apt install mongodb-org
 
# Created a docker volume 
	~ sudo docker volume create mongo_vol_1
# Inspect the volume 
	~ sudo docker inspect mongo_vol_1
# This is the mount path of the volume "/var/snap/docker/common/var-lib-docker/volumes/mongo_vol_1/_data"
## we have to take the path for the "mongo_vol_1" only, no need to mention "_data"
#
## Now create a container with port 27017 , with username and password , and mount the volume to the container and add an image

#
# ~docker run -d --name mongodb_c1 -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=user_1 -e MONGO_INITDB_ROOT_PASSWORD=mypassword -v /var/snap/docker/common/var-lib-docker/volumes/mongo_vol_1:/data/db mongo
	docker run: Command to create and run a new container.

        -d: Runs the container in detached mode (in the background).

        --name mongodb_c1: Assigns the name mongodb_c1 to the container for easy reference.

        -p 27017:27017: Maps port 27017 of the host to port 27017 of the container, allowing you to access MongoDB from your host machine.

        -e MONGO_INITDB_ROOT_USERNAME=user_1: Sets the environment variable for the root username.

        -e MONGO_INITDB_ROOT_PASSWORD=mypassword: Sets the environment variable for the root password.

        -v /var/snap/docker/common/var-lib-docker/volumes/mongo_vol_1:/data/db: Mounts the specified host directory to the container’s /data/db directory. This is where MongoDB stores its data, allowing for data persistence across container restarts.

        mongo: Specifies the image to use, in this case, the official MongoDB image from Docker Hub.

# docker exec -it mongodb mongosh -u "user_1" -p "mypassword" --authenticationDatabase "admin"
	docker exec: Executes a command in a running container.

	-it: Allocates a pseudo-TTY and keeps STDIN open, allowing you to interact with the MongoDB shell.

	mongodb: The name of the running MongoDB container (make sure this matches the name you used when starting the container).

	mongosh: This is the command to start the MongoDB shell.

	-u "user_1": The username you are using to authenticate.

	-p "mypassword": The password for the specified user.
	
	--authenticationDatabase "admin": This specifies the database against which the user is authenticated. This should be the database where the user was created
#
## we have connected to the MongoDB database, Now insert some data
  	test> use food
	switched to db food
	food> db.createCollection("fruits")
	{ ok: 1 }
	food> db.fruits.insertMany([ {name: "apple", origin: "usa", price: 5}, {name: "orange", origin: "italy", price: 3}, {name: "mango", origin: "malaysia", price: 3} ])
#
## exit from the database and the container
## now remove the container, before removing the container we have to stop the container first, then we can remove the container
	~ sudo docker stop mongodb_c1
	~ sudo docker rm mongodb_c1
#
## Now create another container with the same volume "mongo_vol_1", which we used to the previouse container
	~ sudo docker run -d --name mongodb_c2 -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=user_1 -e MONGO_INITDB_ROOT_PASSWORD=mypassword -v /var/snap/docker/common/var-lib-docker/volumes/mongo_vol_1:/data/db mongo
#
# The new container "mongodb_c2", Now connect to the MongoDB database and check for the data
	~ docker exec -it mongodb mongosh -u "user_1" -p "mypassword" --authenticationDatabase "admin"
	
		test> use food
		switched to db food
		food> db.fruits.find().pretty()
#  The data is displayed.
# Mounted the container successfully.
#############################################################################################################################################
##
## 01-11-2024
#
## Installing and running and connecting to couchdb database
Installing , running and Connecting to COUCHDB database

## 1. CouchDB database
	- image : couchdb:3.3.3
	- port : 5984
	- container_name : couchdb_c1
	- volume : couchdb_vol1:/opt/couchdb/data
## 2. Create a container for COUCHDB database
#
	$docker run -d --name couchdb_c1 -p 5984:5984 -e COUCHDB_USER=user_1 -e COUCHDB_PASSWORD=mypassword -v couchdb_vol1:/opt/couchdb/data --restart always couchdb:3.4.2
#

## * Explanation of Command Parameters:
	-d: Runs the container in detached mode (in the background).
	--name couchdb_c1: Names the container couchdb_c1.
	-p 5984:5984: Maps port 5984 on the host to port 5984 in the container, allowing external access to CouchDB.
	-e COUCHDB_USER=user_1 and -e COUCHDB_PASSWORD=mypassword: Sets the admin username and password for CouchDB.
	-v couchdb_vol1:/opt/couchdb/data: Mounts a volume couchdb_vol1 to persist CouchDB data on the host.
	--restart always: Configures the container to restart automatically if it stops.
#


## * It is not possible to create a default database for couchdb , while creating a database container."/opt/couchdb/data" is the default storage location path in the container
## can't connect through the container commandline , connect through a browser

	- http://localhost:5984/_utils/ (or) replace 'localhost' with the Ip address of the server


# Insert some data like creating a database or tables
# 3. Remove or stop the container and create another container with same volume mount
# 4. Check if the data exist or not
###############################################################################################################

# 02-11-2024
#
# * Studying about Linux From Scratch
# * studying about connection between prometheus and grafana
###############################################################################################################
#
# 04-11-2024
#
## Learning and Crearing docker file to create docker image

FROM <image> : This specifies the base image to build

WORKDIR <path> : This specifies the 'working directory' path in image where files will be copied and commands will be executed.

COPY <host-path> <image-path> : This instruction specifies to copy files from the host and put them into the container image

RUN <command> : This instruction tells the builder to run a specific command

ENV <name> <value> : This instruction sets environment variable that a running container will use

Expose <port-number> : This specifies to expose the image to a specific port number

	ex: RUN useradd my-user
	    USER my-user

CMD ["<command>", "<arg>"] : This instruction sets the default command which a container using this image will run

EXAMPLE-1
	FROM ubuntu
	RUN useradd my-user
	USER my-user
 ~docker build -t my-image
 ~docker run -it --name ubuntu-1 my-image bash
* Opened ubuntu-1 container in bash as 'my-user'

EXAMPLE-2
	FROM ubuntu
	RUN useradd my-user && mkdir /dir1 
	WORKDIR /dir1
	USER root
	CMD [ "bash" ]
 ~docker build -t image-1
 ~docker run -it --name ubuntu-2 image-1
* Opened ubuntu-2 container in bash shell as a root user in /dir1 as working directory

ENV - environment variable
 ex: ENV MONGO_INITDB_ROOT_USERNAME=user_1

* To Create a default database in Mongodb database
  1. First create a .js file in same directory

	insert the data given below
		db = db.getSiblingDB("mydatabase");
		db.myCollection.insert({ name: "Sample Document", createAt: new Date() })
  
  2. Save this file as 'init-mongo.js'
  3. Now create a 'Dockerfile'
		FROM mongo
		ENV MONGO_INITDB_ROOT_USERNAME=user_1
		ENV MONGO_INITDB_ROOT_PASSWORD=mypassword
		COPY ./init-mongo.js /docker-entrypoint-initdb.d/
		EXPOSE 27017
  4. Now create/build an image with this Dockerfile and run a container with the image and execute into the container
	~docker exec -it -u "user_1" -p "mypassword" --aauthenticationDatabase "admin"
  5. check the database - >use admin , >show dbs

ADD <src> <destination>

	ex: ADD file1.txt file2.txt /usr/src/things
  1) ADD [--keep-git-dir=<true>] <src> <destination>
	-when we mention this , buildkit adds the contents of the Git repository to image excluding the ".git" directory by default.
  2) ADD --checksum 
	- lets you to verify checksums of remote repo , and only supports HTTP(s) 
	- checksum is formated as algorithms
	- Supported algorithms are sha256, sha384 , sha512

COPY 
	ex: COPY --chown=my-user:my-group --chmod=644 files* /dir1
	    COPY --exclude=*.txt --exclude=*.md hom* /mydir
		- adds all the files name start with 'hom' excluding files with either .txt or .md extension

#########################################################################################################################################
#
# 05-11-2024
#

## Learning about Git and Gitlab actions

 > Scenerio-1
 * Created a common repository "devops-interns"
 * added members 'Rami Reddy' & 'knbabu'
## Rami Reddy created a branch 'login-dev' in his local repo
	~ git branch -M main
	~ git checkout -b login-dev
## Rami Reddy created a file 'login.txt' in login-dev branch
	~ vim index.txt
	~ git add index.txt
	~ git commit -m "initial commit"
## Connected to Remote repository
	~ git remote add origin <remote repo url>
## And pushed the commit to the remote repo
	~ git push -uf origin logn-dev
## Pushed successfully
#
## Now Nagendra created same branch 'login-dev' in his local repo
	~ git branch -M main
	~ git checkout -b login-dev
## Nagendra created a file 'notifi.txt' in login-dev branch
	~ vim notifi.txt
	~ git add notifi.txt
	~ git commit -m "1st commit"
## Connexted to Remote repo
	~ git remote add origin <remote repo url>
## Pushed the commit file to remote repo
	~ git push -uf origin login-dev
## push failed
# Reason
	- The repo already have some data, which Rami_Reddy pushed earlier
 * When we push a file into remote repo from our local branch GIT will compare the our local branch and remote branches
 * If our local branch doesn't have the files, which the remote repo branch have, then we have to pull these extra files from remote repo branch and the push our new file into the remote repo.
#
	~ gir fetch origin
	~ git pull origin <remote branch>
	~ git push -uf origin <local branch>
# * If we encounter any errors while pulling run these commands below
 * ~git config pull.rebase false
 * ~git config pull.rebose true
 * ~git config pull.ff only
# * When we create new from an existing branch, all the files in the existing branch will be copied into new branch 
#############################################################################################################################################
# 06-11-2024

# Creating a Redis docker container
#
- [Docker](https://docs.docker.com/get-docker/) installed on your system
- [Docker Compose](https://docs.docker.com/compose/install/) installed


## There are two docker images for redis,	
 * redis/redis-stack contains both Redis Stack server and Redis Insight. This container is best for local development because you can use the embedded Redis Insight to visualize your data.

 * redis/redis-stack-server provides Redis Stack server only. This container is best for production deployment
#
## To create a Redis docker container run below command
```bash
sudo docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 -v redis-data:/data redis/redis-stack
```
## To connect to the redis-stack run the command
```bash
sudo docker exec -it redis-stack redis-cli
```
 * After Exwcuting the above command , Insert some data
#
 * Sample Data
```redis
HSET user:1000 name "John Doe"
HSET user:1000 age 30
HSET user:1000 country "USA"
```
 * To view the data
```redis
HGETALL user:1000
```
## After inserting data and exited from redis, We must save the data manually
```bash
sudo docker exec -it redis-stack redis-cli SAVE
```
 * Once executing the above command the output will be "OK"
 * It means the data we insert will be saved 
#
#############################################################################################################################################
############################################################################################################################################
# 07-11-2024
## Creating COUCHDB docker container
#
- [Docker](https://docs.docker.com/get-docker/) installed on your system
- [Docker Compose](https://docs.docker.com/compose/install/) installed

## Installing and running and connecting to couchdb database

##  CouchDB database
	- image : couchdb:3.3.3
	- port : 5984
	- container_name : couchdb_c1
	- volume : couchdb_vol1:/opt/couchdb/data
##  Create a container for COUCHDB database
```bash
sudo docker run -d --name couchdb_c1 \
        -p 5984:5984 \
  	-e COUCHDB_USER=user_1 \
  	-e COUCHDB_PASSWORD=mypassword \
  	-v couchdb_vol1:/opt/couchdb/data \
  	--restart always \
  	couchdb:3.4.2
```

## * Explanation of Command Parameters:
	-d: Runs the container in detached mode (in the background).
	--name couchdb_c1: Names the container couchdb_c1.
	-p 5984:5984: Maps port 5984 on the host to port 5984 in the container, allowing external access to CouchDB.
	-e COUCHDB_USER=user_1 and -e COUCHDB_PASSWORD=mypassword: Sets the admin username and password for CouchDB.
	-v couchdb_vol1:/opt/couchdb/data: Mounts a volume couchdb_vol1 to persist CouchDB data on the host.
	--restart always: Configures the container to restart automatically if it stops.


## * It is not possible to create a default database for couchdb , while creating a database container.
 * "/opt/couchdb/data" is the default storage location path in the container
#
## To connect to the couchdb container
## This is only to test if data is being inserted and being stored securely,
## We can connect to database server through application, after checking with this process
```bash
suso docker exec -it container-name bash
```
 - Replace container-name with couchdb_c1

## Insert some data like creating a database or tables
## To create a database in couchdb through bash
```bash
	curl -u user_1:mypassword -X PUT http://localhost:5984/sample_db	
```
## To insert sample data in sample_db through bash
```bash
curl -u user_1:mypassword -X POST http://localhost:5984/sample_db -H "Content-Type: application/json" -d '{
    "name": "John Doe",
    "email": "john.doe@example.com",
    "age": 30,
    "address": {
    "street": "123 Main St",
    "city": "Anytown",
    "zipcode": "12345"
    }
    }'
```
## To check the data 
```bash
curl -u user_1:mypassword -X GET http://localhost:5984/sample_db/_all_docs?include_docs=true
```
#  Remove or stop the container and create another container with same volume mount
#  Check if the data exist or not
```bash
curl -u user_1:mypassword -X GET http://localhost:5984/sample_db/_all_docs?include_docs=true
```
######################################################################################################################################	

## 13-11-2024
# TOMCAT configuration

## 1. Assign a user `tomcat` to /opt/tomcat directory
```bash
sudo useradd -m -d /opt/tomcat
```
`-m` : creates a home directory for tomcat user if it doesn't exist
## 2. Install Java
```bash
sudo apt update
sudo apt install default-JDK
java -version
```
## 3. Install Tomcat zip file
```bash
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.33/bin/apache-tomcat-10.1.33.tar.gz 
```
* Do this in /tmp directory
## 4. Extract the Tomcat zip file to /opt/tomcat 
```bash
sudo tar -xvzf apache-tomcat-10.1.33.tar.gz /opt/tomcat --strip-components=1
```
- `--strip-components=1` : Extract the files to the destination directory, without creating a new directory
## 5. Change the ownership to `tomcat` user
* Changing the ownership of the /opt/tomcat directory to tomcat user
```bash
```
sudo chown -R Tomcat:tomcat /opt/tomcat
## 6. Ch ange execute permission of the `/bin` directory in `/opt/tomcat` directory
```bash
sudo chmod -R u+x /opt/tomcat/bin
```
## 7. Adding username and password
* Add users in tomcat-users.xml located in /opt/tomcat/config
```bash
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>
<roles relename="manager-gui"/>
<roles rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui,admin-gui"/>
</tomcat-users>

```
* Insert this data in to the `tomcat-users.xml` file
## 8. Giving access to connect to Tomcat from anywhere
* Comment some lines in context.xml files located in `/opt/tomcat/webapps/manager/META-INF/context.xml` and `/opt/tomcat/webapps/host-manager/META-INF/context.xml`
```bash
<valve..............     .............0:0:1 />
```
Comment this line
```bash
<!-- <valve ............    .............0:0:1 /> -->
```
Like this


* Create a file for tomcat service in systemd directory located in /etc
* Take the `jdk` path and place it to JAVA_HOME environment variable in tomcat.service file
```bash
sudo update-java-alternatives -l 
```
* Execute this command to get the path of java
* Expected out-put 
#
java-1.11.0-openjdk-amd64		1111		/usr/lib/jvm/java-1.11.0-openjdk-amd64
#
* Thake the above jdk path `/usr/lib/jvm/java-1.11.0-openjdk-amd64` inn tomcat.service file
```bash
sudo nano /etc/systemd/system/tomcat.service
```
```bash
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
```
* Explaination

- This systemd service configuration is for running Apache Tomcat as a service on a Linux system. It specifies the necessary environment variables and commands to start and stop the Tomcat service. Below is an overview and explanation of each section and key directive:
## [Unit] Section:

    `Description`: Provides a short description of the service. Here, it's labeled "Tomcat" to indicate it's for the Apache Tomcat server.
    `After`: Defines the ordering of services. The service will start after the network.target, meaning it will only start after network interfaces are up and available.

## [Service] Section:

    `Type=forking:` This tells systemd that the Tomcat service starts as a background process (forks into the background). Tomcat’s startup script (startup.sh) does this by default.
    `User=tomcat:` The service will run as the tomcat user, which should be a dedicated user created for Tomcat, providing better security.
    Group=tomcat: The service will also run under the tomcat group.

## Environment Variables:

    `JAVA_HOME:` Defines the location of the JDK being used. In this case, it's OpenJDK 11 (/usr/lib/jvm/java-1.11.0-openjdk-amd64).
    `JAVA_OPTS:` Java runtime options for starting Tomcat. The -Djava.security.egd=file:///dev/urandom option helps to improve startup time by using /dev/urandom for cryptographic random number generation.
    `CATALINA_BASE:` The location where Tomcat instance data (logs, configuration, etc.) is stored. This is set to /opt/tomcat.
    `CATALINA_HOME:` The directory where Tomcat is installed. It points to the same directory as CATALINA_BASE in this configuration.
    `CATALINA_PID:` The path to the file that will hold the Tomcat process ID (tomcat.pid), typically used for managing the process.
    `CATALINA_OPTS:` Memory settings and garbage collection options for the Tomcat JVM. These include:
        -Xms512M: Sets the initial heap size to 512 MB.
        -Xmx1024M: Sets the maximum heap size to 1 GB.
        -server: Optimizes the JVM for server-class machines.
        -XX:+UseParallelGC: Uses the Parallel Garbage Collector for improved performance.

## ExecStart and ExecStop:

    `ExecStart:` Specifies the command to start the Tomcat service, which is the startup.sh script located in the /opt/tomcat/bin/ directory.
    `ExecStop:` Specifies the command to stop the Tomcat service, which is the shutdown.sh script located in the same directory.

## Restart and RestartSec:

    `Restart=always:` Ensures that Tomcat is always restarted if it exits, regardless of whether it was stopped manually or crashed.
    `RestartSec=10:` Defines a 10-second delay between when the service stops and when it is restarted.

## [Install] Section:

    `WantedBy=multi-user.target:` This makes the Tomcat service start when the system reaches the multi-user.target, which is typically used for systems with a network but no graphical user interface (GUI).
#



###################################################################################################

# 14-11-2024

# Nginx Reverse Proxy
* Update APT package manager and install nginx
```bash
apt update
apt install nginx
```
* Remove the previous symbolic links if any exists
```bash
unlink /etc/nginx/sites-enabled/default
```
*Create reverse proxy configuration file `reverse-proxy.conf` in `/etc/nginx/sites-available` directory
```bash
cd /etc/nginx/sites-available
nano reverse-proxy.conf
```
- Insert this sample script in reverse proxy config file
```bash
server {
        listen 80;
        listen [::]:80;

        access_log /var/log/nginx/reverse-access.log;
        error_log /var/log/nginx/reverse-error.log;

        location / {
                    proxy_pass http://127.0.0.1:8000;
  }
}

```
* Copy the configuration from /etc/nginx/sites-available to /etc/nginx/sites-enabled. It is recommended to use a symbolic link
```bash
ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf
```
* Test the Nginx configuration file:
```bash
nginx -t
```
* Expected output
```bash
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
* Install Certbot on your Instance by using the APT packet manager:
```bash
apt-get update
apt-get install software-properties-common
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python3-certbot-nginx
```
* Certbot provides a plugin designed for the Nginx web server, automatizing most of the configuration work related to requesting, installing, and managing the TLS certificate:
```bash
certbot --nginx
```
* Answer the prompts that display on the screen to request a valid Let’s Encrypt TLS certificate:
#
################################################################################################
# 15-11-2024

# Deploying F.E. and B.E. and Mysql database
## 1. Insatall Nginx and Update the system
```bash
sudo apt update
sudo apt install nginx
```
## 2. Check the Nginx Status
```bash
sudo systemctl status nginx.service
``` 
## 3. Deploy your website
- Copy or Move your website files to the `/var/www/your-website` location
```bash
sudo mkdir /var/www/your-website
sudo cp -r /path/to/your/frontend/files/* /var/www/your-website
```
## 4. Configure Nginx
- Create a new Nginx configuration file `mywebsite` in `/etc/nginx/sites-available/`
```bash
sudo nano /etc/nginx/sites-available/mywebsite
```
- Insert the following configuration data inside the `mywebsite` file
```bash
server {
    listen 80;
    server_name localhost;

    root /var/www/my-frontend;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
## 5.Enable the configuration
- Create a symbolic link to the `sites-enabled` directory with `sites-available` directory
```bash
sudo ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled
``` 
## 6. Test the Nginx configuration
- we can check the nginx configuration with the Command
```bash
sudo nginx -t
```
## 7. Reload or Restart the Nginx
```bash
sudo systemctl restart nginx
```
## 8. Access your website
- You can access your website through a browser
```bash
http://localhost
```
## Troubleshoot
-  If you encounter any errors Check the Logfile
```bash
sudo tail -f /var/log/nginx/error.log
```
- Ensure port 80 i sopen
```bash
sudo ufw allow 'Nginx HTTP'
```
## Restart the Nginx
```bash
sudo systemctl restart nginx.service
```
## Check in your browser
########################################################################################################################################
#
## Using Teraform to create a vpc with three subnets and creating a one ec2 instance in one of the subnet
## install aws cli
```bash
 sudo apt install aws-cli -y

 ```
 ## check aws-cli is insatlled or not
 ```bash
  aws-cli --version
```
## configure the IAM user credentails
```bash
 aws configure --profile Ram(any_name)
 Here Ram is a profile-name
```
## it asks AWS Access Key ID :
```bash
 AWS Access Key ID [None]: **********
  enter your AWS Acess Key ID
 ```
 ## it asks AWS Secret Access Key :
 ```bash
 AWS Secret Access Key [None]:*********
 enter your AWS Secret Access Key 
```
## it asks Default region name 
```bash
 Default region name [None]: ap-south-1
 
 Replace Region with Required Region
 ```
 ## it asks Default output format
 ```bash 
  Default output format [None]: .json
```
## After the configuration the configuraton files are stored in 
```bash
 cd .aws/config
 cd .aws/credentails
 here we see the config and credentails files

 ```
 ## install terraform using snap
 ```bash
  sudo snap install terraform --classic
```
## check the terraform installed or not 
```bash
 terraform --version
 ```
 
 ### To create a VPC with three subnets in three different availability zones and launch one EC2 instance in one of the subnets using Terraform, you can follow the structure outlined below. This example assumes you have two Terraform files: main.tf for the main configuration and variables.tf for variable definitions. 

 ### Main.tf
 ```bash
  provider "aws" {
  region  = "ap-south-1"  # Change to your desired region
  profile = var.aws_profile
}
# Generate a random suffix for unique resource names
resource "random_id" "suffix" {
  byte_length = 4
}
# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}
# Create public subnets in different availability zones
resource "aws_subnet" "subnet1" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.subnet1_cidr
  availability_zone        = "ap-south-1a"  # Change as needed
  map_public_ip_on_launch  = true
  tags = {
    Name = "Subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.subnet2_cidr
  availability_zone        = "ap-south-1b"  # Change as needed
  map_public_ip_on_launch  = true
  tags = {
    Name = "Subnet2"
  }
}
resource "aws_subnet" "subnet3" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = var.subnet3_cidr
  availability_zone        = "ap-south-1c"  # Change as needed
  map_public_ip_on_launch  = true
  tags = {
    Name = "Subnet3"
  }
}
# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MyInternetGateway"
  }
}
# Create a route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.igw.id
    # This route allows outbound traffic to the internet from the public subnets
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
# Associate the route table with all public subnets
resource "aws_route_table_association" "subnet_association1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "subnet_association2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "subnet_association3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.public_rt.id
}
# Custom security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "SG-1-${random_id.suffix.hex}" # Unique name using random ID
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security-group-1"
  }
}
# EC2 Instance
resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  subnet_id             = aws_subnet.subnet1.id  # Choose subnet1, subnet2 or subnet3
  associate_public_ip_address = var.associate_public_ip
  tags = {
    Name = var.instance_name
  }
  # Optional: Provide a user-data script for initialization
  # user_data = var.user_data != "" ? file(var.user_data) : null
}
# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.instance.public_ip
}
```

### Variable.tf
```bash
 variable "aws_profile" {
  description = "AWS profile for credentials"
  type        = string
  default     = "Ram"  # Set your AWS CLI profile name here
}
variable "ami_id" {
  description = "The AMI ID for the EC2 instance (Ubuntu)"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"  # Example Ubuntu AMI, adjust for your region
}
variable "instance_type" {
  description = "The instance type"
  type        = string

 default     = "t2.micro"  # Adjust as necessary
}
variable "key_pair_name" {
  description = "The name of the existing EC2 key pair"
  type        = string
  default     = "terraform_key_gk"  # The existing key pair name
}
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "ubuntu-1"  # Instance name tag
}
variable "associate_public_ip" {
  description = "Boolean flag to associate a public IP address to the EC2 instance"
  type        = bool
  default     = true
}
variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = ""
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"
}
variable "subnet1_cidr" {
  description = "CIDR block for subnet1"
  default     = "10.10.1.0/24"
}
variable "subnet2_cidr" {
  description = "CIDR block for subnet2"
  default     = "10.10.2.0/24"
}
variable "subnet3_cidr" {
  description = "CIDR block for subnet3"
  default     = "10.10.3.0/24"
}
```
## Displays the installed version of Terraform.
```bash 
 terraform --version
 ```
 ## Initializes the working directory and downloads necessary providers.
 ```bash
  terraform init
  ```
## Validates the configuration files for syntax correctness.
```bash
 terraform validate
```
## Creates an execution plan showing what actions will be taken without applying changes.
  ```bash
   terraform plan
  ```
## Applies the changes required to reach the desired state of the configuration.
```bash
  terraform apply
```
## Destroys all resources managed by Terraform in the current configuration.
```bash
 terraform destroy
```
################################################################################################################################33
#
# Running a Docker compose file to host/run Steelgym application locally
## Install Docker & Docker compose
- Install [Docker](https://docs.docker.com/get-docker/) on your system
- Install [Docker Compose](https://docs.docker.com/compose/install/)
#
## * check the docker with command
```bash
docker --version
```

 * After cloning , use the docker `compose command` where the `docker-compose.yml` file exists.
 * Create a `.env` file where the `docker-compose.yml` file exists, with database details
 ```vim
POSTGRES_DB= "steel_db"
POSTGRES_USER= "postgres"
POSTGRES_PASSWD= "postgres"
 ```
 * Now, run the below docker command
```bash
sudo docker compose up -d
```
```
`sudo`: Runs the command with elevated privileges (administrator access). This is typically needed if Docker is installed in a way that requires admin rights to run.
`docker compose`: This is the Docker Compose command-line tool used to manage multi-container Docker applications. (Note: docker compose should be used instead of docker-compose as of Docker Compose V2.)
`up`: This command builds, (re)creates, and starts the containers as specified in the docker-compose.yml file.
`-d`: The -d flag runs the containers in "detached" mode, meaning they will run in the background, freeing up your terminal.
```
## Docker compose file
- This is the docker compose file
```yml
version: "3.8"

services:
  steel_db:
    image: postgres:15
    container_name: steel_db
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWD}
    networks:
      steelgym-default:
        ipv4_address: 172.18.0.4  # Corrected to be within the 172.18.0.0/24 subnet
    ports:
      - "5432:5432"
    volumes:
      - ./postgres:/var/lib/postgresql/data
      - ./steel_dev_db_11_04_2024.sql:/docker-entrypoint-initdb.d/steel_dev_db_11_04_2024.sql

  redis:
    image: redis:5
    container_name: redis-server
    networks:
      steelgym-default:
        ipv4_address: 172.18.0.5
    ports:
      - "6379:6379"

  backend:
    build:
      context: ./steelgym_backend
      dockerfile: Dockerfile
    container_name: steelgym-backend
    networks:
      steelgym-default:
        ipv4_address: 172.18.0.3
    ports:
      - "8000:8000"
    depends_on:
      - steel_db
      - redis

  ui:
    build:
      context: ./steelgym_ui
      dockerfile: Dockerfile
    container_name: steelgym_ui
    networks:
      steelgym-default:
        ipv4_address: 172.18.0.2
    environment:
      - API_URL=http://172.18.0.3:9000  # The API URL points to backend's static IP
    ports:
      - "4200:4200"
    depends_on:
      - backend

networks:
  steelgym-default:
    driver: bridge  # Create a bridge network for communication between containers
    ipam:
      config:
        - subnet: 172.18.0.0/24  # Define a subnet for static IPs

```
## Dockerfile for Front-End
```sh
### STEP-1 BUILD

FROM node:14-alpine3.15 AS node-helper

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm cache clean --force

RUN npm install

COPY . .

RUN npm install -g @angular/cli@15.2.11

# Use 'ng serve' instead of 'ng build' for development
CMD ["ng", "serve", "--configuration=development", "--host", "0.0.0.0", "--port", "4200"]

```
## Dockerfile for Back-End
```sh
FROM python:3.9-slim

WORKDIR /app

COPY . /app

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000 

CMD ["uvicorn", "main:app", "--reload"]

```

#
`sudo`: Runs the command with elevated privileges (administrator access). This is typically needed if Docker is installed in a way that requires admin rights to run.
`docker compose`: This is the Docker Compose command-line tool used to manage multi-container Docker applications. (Note: docker compose should be used instead of docker-compose as of Docker Compose V2.)
`up`: This command builds, (re)creates, and starts the containers as specified in the docker-compose.yml file.
`-d`: The -d flag runs the containers in "detached" mode, meaning they will run in the background, freeing up your terminal.
#

* This command will create four docker containers one for Front-End, one for Back-End, one for Postgresql and one for Redis database
* After successful execution, check the docker containers whether they are running or not, with below command.
```bash
sudo docker ps -a
```
#
`sudo`: Runs the command with elevated privileges (administrator access). This is required if Docker is installed in a way that needs administrator rights to interact with Docker.
`docker`: The main command for interacting with Docker.
`ps`: Stands for "process status." It is used to list containers, just like how ps lists processes on a system.
`-a`: This flag tells Docker to show all containers, not just the ones that are currently running. This includes containers that are stopped or exited.
#
* Exoected output
```sh
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                       NAMES
c01814fe5a1b   steelgym-ui        "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:4200->4200/tcp, :::4200->4200/tcp   steelgym_ui
197769246ca1   steelgym-backend   "uvicorn main:app --…"   3 minutes ago   Up 3 minutes   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   steelgym-backend
c514337a74f3   postgres:15        "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   steel_db
65e2be7ea8b3   redis:5            "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp   redis-server

```
* Check the output, If all containers are running ports will be visible













