up:

down:

build_mariadb:
	docker kill mariadb; \
	docker image rm --force mariadb:inception; \
	cd ./srcs/requirements/mariadb; \
	docker build --tag=mariadb:inception .;

rebuild_mariadb:
	cd ./srcs/requirements/mariadb; \
	docker kill mariadb; \
	docker image rm --force mariadb:inception; \
	docker system prune; \
	docker build --tag=mariadb:inception .;

run_mariadb:
	docker run --detach --name=mariadb mariadb:inception

build_wordpress:
	docker kill wordpress; \
	docker image rm --force wordpress:inception; \
	cd ./srcs/requirements/wordpress; \
	docker build --tag=wordpress:inception .;

run_wordpress:
	docker run --interactive --tty --detach --name=wordpress wordpress:inception

install_wordpress:
	docker exec wordpress ./wp_cli_install.sh

build_nginx:
	docker kill nginx; \
	docker image rm --force nginx:inception; \
	cd ./srcs/requirements/nginx; \
	docker build --tag=nginx:inception .;

run_nginx:
	docker run -p 127.0.0.1:4321:443 --interactive --tty --detach --name=nginx nginx:inception

connect:
	docker network create inception; \
	docker network connect inception mariadb; \
	docker network connect inception wordpress; \
	docker network connect inception nginx;

kill_all:
	docker kill nginx; \
	docker kill wordpress; \
	docker kill mariadb;

sysprune:
	docker system prune --all --force --volumes

.PHONY: build_mariadb rebuild_mariadb
