.PHONY: setup
setup:
	docker-compose build
	docker-compose run --rm app bin/setup

.PHONY: run
run:
	docker-compose up

.PHONY: sh
sh:
	docker-compose exec app bash

.PHONY: migrate
migrate:
	docker-compose run --rm app ./bin/rails db:migrate

.PHONY: seed
seed:
	docker-compose run --rm app ./bin/rails db:seed
