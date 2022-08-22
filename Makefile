## Variables ##

knexfile := dist/config/knexfile.js
DC_RUN = docker-compose run --rm
DC_UP = docker-compose up

## Rules ##
build:
	docker-compose build --force-rm --no-cache --parallel

infra:
	docker-compose up -d --force-recreate

stop:
	docker-compose stop

down:
	docker-compose down

clean:
	docker-compose down --rmi all -v --remove-orphans

# MIGRATE


migrate:
	$(DC_RUN) api-service npx knex migrate:latest --knexfile=$(knexfile)
	# npx knex migrate:latest --knexfile="./dist/src/config/knexfile.js"

migrate-undo:
	$(DC_RUN) api-service npx knex migrate:rollback --knexfile=$(knexfile)

seed:
	$(DC_RUN) api-service npx knex seed:run --knexfile=$(knexfile)

rollback:
	$(DC_RUN) api-service npx knex migrate:rollback --knexfile=$(knexfile)

run:
	$(MAKE) clean
	$(MAKE) infra
	sleep 10
	$(MAKE) migrate
	$(MAKE) seed