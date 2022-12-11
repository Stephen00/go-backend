default: help

help: # show list of Makefile commands
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

postgres: # create a new running postgres container from the postgres image
	docker run --name postgres15 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb: # create a new postgres database inside the postgres container	
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb: # drop the postgres database in the container
	docker	 exec -it postgres15 dropdb simple_bank

migrateup: # upward migration to the database
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown: # downward migration from the database
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc: # generates fully type-safe code from SQL queries
	docker run --rm -v $(CURDIR):/docs -w /docs kjconroy/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc help

