# ---------------------------------------------------------------------------- #
all: up

clean: down

fclean: nuke

re: fclean all
# ---------------------------------------------------------------------------- #
up:
	if ! grep -q ${USER} /etc/hosts; then \
		echo "127.0.0.1	${USER}.42.fr" | doas tee -a /etc/hosts > /dev/null; \
	fi
	mkdir -p ${HOME}/data/mariadb
	mkdir -p ${HOME}/data/wordpress
	docker compose \
		--file ./srcs/docker-compose.yml \
		--env-file ./srcs/.env \
		up --detach

down:
	docker compose \
		--file ./srcs/docker-compose.yml \
		--env-file ./srcs/.env \
		down --volumes

rmi:
	docker rmi --force mariadb:inception
	docker rmi --force wordpress:inception
	docker rmi --force nginx:inception

build:
	docker compose \
		--file ./srcs/docker-compose.yml \
		--env-file ./srcs/.env \
		build

rebuild: rmi
	docker compose \
		--file ./srcs/docker-compose.yml \
		--env-file ./srcs/.env \
		build --no-cache

nuke: down rmi
	if grep -q ${USER} /etc/hosts; then \
		doas sed -i "/${USER}/d" /etc/hosts; \
	fi
	doas chown -R ${USER} ${HOME}/data
	rm -rf ${HOME}/data
	docker system prune --force --volumes

# ---------------------------------------------------------------------------- #
.PHONY: all clean fclean re up down rmi build rebuild nuke
# ---------------------------------------------------------------------------- #
