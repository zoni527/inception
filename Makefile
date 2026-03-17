up:
	mkdir -p ${HOME}/data/mariadb
	mkdir -p ${HOME}/data/wordpress
	cd ./srcs; \
	docker compose --env-file .env up --detach

down:
	cd ./srcs; \
	docker compose down -v

nuke: down
	sudo chown -R ${USER} ${HOME}/data
	rm -rf ${HOME}/data
	docker rmi --force mariadb:inception
	docker rmi --force wordpress:inception
	docker rmi --force nginx:inception
	docker system prune

.PHONY: up down nuke
