# Inception

## Docker commands

```sh
docker image ls
docker images
docker container ls
docker ps
docker volume ls
docker network ls

docker inspect <entity>

docker pull <image>

docker run [options] <image> [commands]
docker start <container>
docker stop <container>
docker pause <container>
docker unpause <container>

docker exec [options] <container> <command>

docker logs [options] <container>

docker run ubuntu sh -c 'echo "Hello, world!"'

docker cp <./path_to_file/on_host> <name_of_container>:<path_to_file/on_container>

docker diff

# Create new image from modified running image
docker commit <container id> <new image name>

# Build image from dockerfile
docker build -t <name> .

docker kill <container>

docker cp ./<some_file> <container_id>:/path/to/wherever
```
