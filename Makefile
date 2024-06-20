LOGIN=lumedeir
VOLUMES_PATH=/home/${LOGIN}/data

export VOLUMES_PATH
export LOGIN

SYSTEM_USER = $(shell echo $$USER)
DOCKER_CONFIG = $(shell echo $$HOME/.docker)

all: setup up

host:
	@if ! grep -q "${LOGIN}.42.fr" /etc/hosts; then \
		sudo sed -i "2i\127.0.0.1\t${LOGIN}.42.fr" /etc/hosts; \
	fi
host-clean:
	sudo sed -i "/${LOGIN}.42.fr/d" /etc/hosts

DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml
DOCKER_COMPOSE_COMMAND=docker-compose -f $(DOCKER_COMPOSE_FILE)

# inicia os contêineres em segundo plano
up: build
	$(DOCKER_COMPOSE_COMMAND) up -d

# constrói as imagens Docker 
build:
	$(DOCKER_COMPOSE_COMMAND) build


# down: Para e remove os contêineres, redes e volumes criados pelo docker-compose up.
# --rmi all: Remove todas as imagens associadas aos serviços no arquivo docker-compose.
# --volumes: Remove todos os volumes associados aos contêineres.
clean: host-clean
	$(DOCKER_COMPOSE_COMMAND) down --rmi all --volumes

fclean: clean
	docker system prune --force --all --volumes
	sudo rm -rf /home/${LOGIN}

setup: host
	sudo mkdir -p ${VOLUMES_PATH}/mariadb
	sudo mkdir -p ${VOLUMES_PATH}/wordpress

prepare:	update compose

update:
			@echo "${YELLOW}-----Updating System----${NC}"
			sudo apt -y update && sudo apt -y upgrade
			@if [ $$? -eq 0 ]; then \
				sudo apt -y install docker.io && sudo apt -y install docker-compose; \
				if [ $$? -eq 0 ]; then \
					echo "${GREEN}-----Docker and docker-compose installed-----${NC}"; \
				else \
					echo "${RED}-----Docker or docker-compose installation failed-----${NC}"; \
				fi \
			else \
				echo "${RED}-----System update failed-----${NC}"; \
			fi

compose:
			@echo "${YELLOW}-----Updating Docker Compose to V2-----${NC}"
			sudo apt -y install curl
			mkdir -p ${DOCKER_CONFIG}/cli-plugins
			curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ${DOCKER_CONFIG}/cli-plugins/docker-compose
			chmod +x ${DOCKER_CONFIG}/cli-plugins/docker-compose
			sudo mkdir -p /usr/local/lib/docker/cli-plugins
			sudo mv /home/${SYSTEM_USER}/.docker/cli-plugins/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
			@echo "${GREEN}-----Docker Compose updated-----${NC}"

.PHONY: all up build clean fclean setup host update compose prepare
