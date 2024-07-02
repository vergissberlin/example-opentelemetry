
up:
	docker compose up -d --remove-orphans
	make run

down:
	docker compose down -v

logs:
	docker compose logs -f

pull:
	docker compose pull

status:
	docker compose ps

ps: status

run:
	cd app && flutter run -d macos

restart: down
	make up

default: restart
