up:
	docker compose -f compose.yml up -d --remove-orphans --build

down:
	docker compose -f compose.yml down -v

logs:
	docker compose -f compose.yml logs -f

pull:
	docker compose -f compose.yml pull

status:
	docker compose ps

build:
	docker compose -f compose.yml build

ps: status

restart: down
	make up


default: restart
