ci: build-prod push
start: build
	docker-compose -f docker-compose.dev.yml up -d

build:
	docker-compose -f docker-compose.dev.yml build

down:
	docker-compose -f docker-compose.dev.yml down

attach:
	docker-compose -f docker-compose.dev.yml exec web /bin/bash

build-prod:
	docker-compose -f docker-compose.prod.yml build

prod:
	docker-compose -f docker-compose.prod.yml up

push:
	docker-compose -f docker-compose.prod.yml push

db-migrate:
	docker-compose -f docker-compose.dev.yml exec web /var/www/html/vendor/bin/phinx migrate

db-rollback:
	docker-compose -f docker-compose.dev.yml exec web /var/www/html/vendor/bin/phinx rollback

db-seed:
	docker-compose -f docker-compose.dev.yml exec web /var/www/html/vendor/bin/phinx seed:run

