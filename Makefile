up:
	line="127.0.0.1	${USER}.42.fr"; \
	if ! grep -q ${USER} /etc/hosts; then \
		echo ${line} | doas tee -a /etc/hosts > /dev/null; \
	fi
	mkdir -p ${HOME}/data/mariadb
	mkdir -p ${HOME}/data/wordpress
	docker compose \
		--file ./srcs/docker-compose.yml \
		--env-file ./srcs/.env \
		up --detach

down:
	cd ./srcs; \
	docker compose down -v

nuke: down
	if grep -q ${USER} /etc/hosts; then \
		doas sed -i "/${USER}/d" /etc/hosts; \
	fi
	doas chown -R ${USER} ${HOME}/data
	rm -rf ${HOME}/data
	docker rmi --force mariadb:inception
	docker rmi --force wordpress:inception
	docker rmi --force nginx:inception
	docker system prune

.PHONY: up down nuke
