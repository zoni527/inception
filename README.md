*This project has been created as part of the 42 curriculum by jvarila.*
# Description
The inception project aims to familiarize the 42 student with docker, containers,
images, and docker compose. The goal is to run a simple WordPress site using
three docker containers, orchestrated by docker compose. These containers consist
of an nginx server, a WordPress frontend, and a MariaDB database.

The images have to be defined via Dockerfiles, and must be based on either the
penultimate official stable Alpine or Debian image at the time of working on the
project.

I aimed for easy modification, which for this project meant connecting the `.env`
file's values as seamlessly as possibly. This involves multiple levels of inheritance
(`.env`->`docker-compose.yaml`->`Dockerfile`->`script files`) and is achieved using
environment variables, build time arguments, and modifying config files using `envsubst`
and `sed`.
## Requirements & dependencies
- Linux Kernel (through OS, VM, WSL...)
- Git
- GNU Make
- Docker
- Docker Compose
## Comparisons
### Virtual Machines vs Docker
Virtual machines run on a hypervisor which simulates a computer's hardware.
The virtual machine's operating system and software then run on top of that
hypervisor.

In contrast Docker runs containers which are isolated collections of dependencies
(OS and software) that run on top of the existing Linux Kernel of the host operating
system, so no hypervisor. This is more light weight than running a VM. Isolation is
achieved using Linux namespaces.
### Secrets vs Environment Variables
Environment variables are available in each container shell that inherit them,
both during build and runtime.

Secrets have to be explicitly selected one by
one for each container, and docker saves them in an encrypted state.
### Docker Network vs Host Network
Docker networks by default are isolated bridge networks, meaning that you can't
connect to containers from the host by default. Only containers can communicate with
each other over the bridge(s). This is good for security as the containers are
isolated from the host and internet. Also published ports in the docker network
don't collide with the host network, meaning if 443 is taken on the host you can
still use it in the docker network.

You can make specific container ports available to the host/the internet by
publishing ports, `127.0.0.1:<host port>:<container port>` for only host
access, `[0.0.0.0:]<host port>:<container port>` for the whole network.

You can also make a docker network with network mode `host`, but then all container
ports will be accessible from the host/the whole internet, depending if you limit
the access IP. This can be dangerous and/or increase the risk of port collisions.
### Docker Volumes vs Bind Mounts
Docker volumes are like virtual hard drives that can persist over the lifetime
of containers, which would normally lose their runtime context when stopped.

Bind mounts (which can be used by volumes too) connect host directories/files
to containers, meaning that you can transfer data between the container and
host by accessing the same directories/files.
# Instructions
[Project GitHub repo](https://github.com/zoni527/inception)

Check [DEV_DOC.md](DEV_DOC.md) for helpful scripts and [USER_DOC.md](USER_DOC.md) for runtime tips.

The vogsphere (42) repository isn't allowed to contain an environment file or secrets
(files containing login credentials and/or keys). To get the project working
clone the repository, create a `.env` file and place it in the `srcs` folder.

By default secrets reside in `secrets`. The required secret files are:
- mariadb_user.txt
- mariadb_user_password.txt
- mariadb_root_password.txt
- wordpress_admin.txt
- wordpress_admin_email.txt
- wordpress_admin_password.txt
- wordpress_user.txt
- wordpress_user_email.txt
- wordpress_user_password.txt

To run the project just run `make`, to stop the containers `make down`, to remove created
data `make fclean`.
# Resources
## Links
### Wordpress
- [Basic installation](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)
- [Wordpress config creation using wp client](https://developer.wordpress.org/cli/commands/config/create/)
- [php FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
### MariaDB
- [Remote access guide](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-remote-connection-guide)
- [Database install CLI program](https://mariadb.com/docs/server/clients-and-utilities/deployment-tools/mariadb-install-db/)
### nginx
- [Example](https://nginx.org/en/docs/example.html)
- [Beginners guide](https://nginx.org/en/docs/beginners_guide.html)
- [Nginx setup examples](https://developer.wordpress.org/advanced-administration/server/web-server/nginx/)
- [Using environment variables in nginx config](https://www.baeldung.com/linux/nginx-config-environment-variables)
### Various
- [Difference between ports and expose](https://stackoverflow.com/questions/40801772/what-is-the-difference-between-ports-and-expose-in-docker-compose)
- [Replace whole line with sed](https://stackoverflow.com/questions/11245144/replace-whole-line-containing-a-string-using-sed)
- [Avoiding docker's cache in builds](https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk)
- [OpenSSL request options](https://docs.openssl.org/master/man1/openssl-req/#options)
## AI use
I troubleshooted the communication between nginx and WordPress using ChatGPT,
Claude and Gemini. Interistingly Gemini worked best for me, and it found some
typos and wrongly associated values. It also suggested some improvements for
the modularity and adaptibility of the project which I implemented, moving some
build time code into runtime (so `ENTRYPOINT ["<script_name>.sh"]` instead of
`RUN`).

I also had an issue with changing ports between runs, and Gemini helped me pinpoint
the culprit which was the `wp` CLI program that failed unexpectedly when changing
ports because it was using the old config value to contact MariaDB, but when it
couldn't connect it would fail. The solution was using `sed` instead to change the
`DB_HOST` value in the WordPress config, which includes the new port.

Otherwise I avoided using AI as much as possible to use primary sources, ask peers,
and build my troubleshooting skills. Call me old fashioned.
