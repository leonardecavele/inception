COMPOSE = sudo docker compose --env-file srcs/.env -f srcs/docker-compose.yml

.PHONY: all up down re ps logs

all: up

up:
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

re:
	$(COMPOSE) down
	$(COMPOSE) up --build -d

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs
