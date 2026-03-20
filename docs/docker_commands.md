# Docker commands
## Listing
```sh
docker image ls
docker images
docker container ls
docker ps
docker volume ls
docker network ls
```
## Inspecting
```bash
docker [category] inspect <entity>
```
## Pulling
```bash
docker pull <image>
```
## Running
```bash
docker run [options] <image> [commands]
docker start [options] <container>
docker stop [options] <container>
docker pause <container>
docker unpause <container>
docker exec [options] <container> <command>
```
## Logs
```bash
docker logs [options] <container>
docker exec <container> cat <path/to/logfile>
```
## Inspect runtime changes
```bash
docker diff <container>
```
## Commit runtime changes
```bash
docker commit [options] <container> <new_image_name>
```
## Build image from Dockerfile
```bash
docker build [--tag <name>] [--file <filename>]
```
## Killing
```bash
docker kill <container>
```
## Copying files
```bash
docker cp ./<some_file> <container>:/path/to/wherever
```
