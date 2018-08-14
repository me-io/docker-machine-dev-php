# docker-medev-machine

> Development machine for the backend team

We use docker as our main development environment, it helps us maintain consistency between dev and production environments, if this is your first steps into docker world, please read this article about docker and how different it is from virtual machines and then come back and proceed.

## 1. Installing the tools:
* first you need to install Homebrew and Cask, you can do so by running following commands in sequence 

```
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew doctor //this is just to make sure Homebrew installed successfully

brew tap caskroom/cask
brew install cask
```

* Then you need to install virtualbox, since our docker's setup relies on a virtual machine that is powered by virtualbox,
if you have it installed you can skip this step otherwise open up your terminal and run this command:
```
brew cask install virtualbox
```

* Then install docker and its tools
if you have it installed you can skip this step otherwise  run this command:
```
brew install docker docker-compose docker-machine
```

* Then install docker credentials helper 
if you have it installed you can skip this step otherwise run this command:
```
brew install docker-credential-helper
```

## 2. Prepare the workspace:
To create the workspace directory run the following command
```
mkdir ~/Workspace/medev
```
now lets make sure that we have the write permission on the workspace
```
sudo chmod 777 ~/Workspace/medev
```
now lets cd in
```
cd ~/Workspace/medev
```
now lets clone the `medev-machine` repository
```
git clone https://github.com/medev/medev-machine
```
cd to it 
```
cd medev-machine
```

> Make sure that you are on master branch


## 3. Creating the virtual machine:

* To create the virtual machine with the name `dev` using the following command
```
docker-machine create --driver virtualbox --virtualbox-cpu-count 4 --virtualbox-memory "8096" --virtualbox-disk-size "20000" dev
```
now lets make sure that the machine is running
```
docker-machine start dev
```

* Now lets do some clean up and preparations for mounting the projects properly by running these commands one after another
```
docker-machine stop dev
VBoxManage sharedfolder remove dev --name Users
VBoxManage sharedfolder add dev --name Users --hostpath /Users --automount
docker-machine start dev
```

* Now lets create the projects directories and mount them properly to NFS file system plus adding their DNS info to the hosts file
this can be done using the prepare.sh script, can be executed using the following command
```
sudo ./prepare.sh
```
to know your machine's ip address run the following command,
```
docker-machine ip dev
```
if the ip doesn't equal to 192.168.99.100, it means that something went wrong, you have to start over, otherwise continue

* Now you need to restart the virtual machine and remount the the project directories to the NFS
```
docker-machine restart dev
sudo ./prepare.sh
```

* If you already have a docker account you can skip signing up, otherwise got to [https://hub.docker.com](https://hub.docker.com) and create your account
after that run the following command and login with your credentials
```
docker login
```

now lets make sure that the the projects directories are mounted properly by running the script again
```
sudo ./prepare.sh
```

* Now lets prepare the env variables by running the below two commands one after another
```
docker-machine env dev
eval "$(docker-machine env dev)"
```

* Final step is to start the container and the services with the following command 
```
docker-compose up -d
```

* To ssh into the machine use the following command
```
ssh www-data@192.168.99.100 -p 2222
```
