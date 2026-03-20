*This project has been created as part of the 42 curriculum by jvarila.*
# Description
The inception project aims to familiarize the 42 student with docker, containers,
images, and docker compose. The goal is to create a simple WordPress site using
three docker containers, orchestrated by docker compose. These containers consist
of an nginx server, a WordPress frontend, and a MariaDB backend database.

The images have to be defined via Dockerfiles, and must be based on either the
penultimate official stable Alpine or Debian image at the time of working on the
project.

I aimed for easy modification, which for this project meant connecting the `.env`
file's values as seamlessly as possibly, which means multiple levels of inheritance
(`.env`->`docker-compose.yaml`->`Dockerfile`->`script files`). This can be done using
environment variables, build time arguments, and modifying config files using `envsubst`
and `sed`.
## Requirements
- Linux Kernel (through OS, VM, WSL...)
- make
- docker
- docker compose
## Comparisons (required for evaluation)
### Virtual Machines vs Docker
Virtual machines run on a hypervisor which simulates a computer's hardware.
The virtual machine's operating system and software then run on top of that
hypervisor. In contrast Docker runs containers which are isolated packages
of dependencies (OS and software) that run on top of the existing Linux
Kernel of the host operating system, so no hypervisor. Isolation is achieved
using Linux namespaces.
### Secrets vs Environment Variables
Environment variables are available in each container shell that inherit them,
both during build and runtime. Secrets have to be explicitly selected one by
one for each container, and docker saves them in an encrypted state.
### Docker Network vs Host Network
Docker networks by default are isolated bridge networks, meaning that you can't
connect to the containers through the host's regular network. This is good for
security as there is no easy direct interface to every container. You can make
selected ports in selected containers available to the host/the internet by
publishing ports, `127.0.0.1:<host port>:<container port>` for only host
access, `[0.0.0.0:]<host port>:<container port>` for the whole network.
### Docker Volumes vs Bind Mounts
Docker volumes are like virtual hard drives that can persist over the lifetime
of containers, which would normally lose their runtime context when stopped.
Bind mounts (which can be used by volumes too) connect host directories/files
to containers, meaning that you can transfer data between the container and
host by accessing the same directories/files.
# Instructions
[Project GitHub repo](https://github.com/zoni527/inception)

The vogsphere (42) repository isn't allowed to contain a .env file or secrets
(files containing login credentials and/or keys). To get the project working
clone the repository, create a `.env` file and place it in `./srcs` folder, `.`
meaning the root of the repository.

By default secrets reside in `./secrets`. The required secret files are:
- mariadb_user.txt
- mariadb_user_password.txt
- mariadb_root_password.txt
- wordpress_admin.txt
- wordpress_admin_email.txt
- wordpress_admin_password.txt
- wordpress_user.txt
- wordpress_user_email.txt
- wordpress_user_password.txt
# Resources
## Links
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
