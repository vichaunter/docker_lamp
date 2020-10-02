# Docker LAMP ready to run

Docker LAMP is purely a lamp service to serve any website you will need.

It has included all packages needed to run for example:

* Symfony
* Wordpress
* Nette
* and any other php 7.4 compatible website

If you find that for some deployment you miss some package, feel free to send an update with that missing packages included or left a comment.

## The idea behind

Is right now created thinking to use it under linux, that is why there is `.env` and `Makefile`.

Anyway you can run it in other platforms that can be not compatible just replacing the variables inside
`docker-compose.dev.yml` and executing the commands from `Makefile` manually.

I made this package, mainly to have a source where to get the lamp deployment that i know it works for each of my projects, so feel free to improve it also.

Also because is much easier to just run `make start`, than caring about everything that is inside, and this way you don't need to know nothing about docker to make it run.

## How to use it

The main target, is to have a subfolder called `docker` (or any other fancy name you want) inside your project `[root_path]`, that will live together with your project and you can update and manage (even i'm using it for CI/CD).

So, the first step, will be to clone this project inside your main project folder:
```
git clone git@github.com:vichaunter/docker_lamp.git docker
```

Now that you have it cloned in `docker` folder, go to it and edit `.env` file, looks something like this:
```
NAME=mydockercontainername
PORT_WEB=34510
PORT_DB=34516
PORT_PHPMYADMIN=34511
PUBLIC_FOLDER=public
```

Where you just need to replace values for what you need for your project.

> I did it like this, because this way, you can have more than one projects running at once, just be sure to not collide the name and ports and all should be fine.

Next and last step if you have properly installed docker (if not go under, i left you how for debian/ubuntu), is to run from inside docker folder:
```
make run
```

It can take a while, give it time due it will compile php extensions (only the first time).

This will map your project folder inside docker, and will use the subfolder `PUBLIC_FOLDER` as apache base folder, all inside `/var/www/html`.

After it boots, will show a message as dockers are already running. In this moment you can acces to your local:
```
http://localhost:34510
```

There will load the website you have inside `PUBLIC_FOLDER`. For example, Symfony will be public, Wordpress should load the same folder (.) Nette will load www, etc...

There is also phpmyadmin installed to allow you to manage database. In case you want to use any other software, just use your defined port and ignore this:
```
http://localhost:34511
```

I like to give normally the next port than the website, and for database the same port ending in 6.

## How to manage docker instance

Makefile has all needed commands for daily usage:
```
# for run all dockers (it build it if is not builded)
make start

# for stop and delete it
make down

# to enter in web docker instance
make attach
```

There is more commands to use with CI/CD but to use it you should create the files, due normally development and production are different and depends on each project.

## If you miss something

I use to not use too big installations commands, due time to time Dockerfile should be changed with additions or removals, and if you have splitted installation commands it will not require to reinstall all.

### Linux packages

I recommend you to add any required package after `line 29`, adding it to the list due will be executed the very first if any other extensions later on require it.

### PHP packages

There is in Dockerfile around `line 35` commands starting with `docker-php-ext-install`, you can add any of the packages listed here if you need:

* https://gist.github.com/vichaunter/3cd4428f4c74fc0bb54fd098aad5465b#file-gistfile1-txt

### docker and docker-compose

If you don't have any of this two packages, install them is a "pair of commands" (in case of debian/ubuntu):
```
#Debian 9/10+, Ubuntu 18+

#clean first only in case some rubbish was left there
sudo apt-get remove docker docker-engine docker.io containerd runc

#prerequisites
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -    
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"    
   
#Install docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

#Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version
sudo docker run hello-world
```
After this, you should see docker-compose version, and also a small example that prints `Hello world` on terminal

For other distros or OS, just take a look in their official documentation:

* Docker: https://docs.docker.com/engine/install/
* Docker-compose: https://docs.docker.com/compose/install/

And that is all!, if you have any kind of problem, just let me know in issues. You can also contact me in my website https://www.vichaunter.org

