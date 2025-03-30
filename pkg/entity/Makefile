.PHONY: install
# install atlas
install:
	curl -sSf https://atlasgo.sh | sh

.PHONY:
# generate ent
generate:
	go generate ./...

.PHONY: migrate-diff
# migrate diff
migrate-diff:
	@if [ -z "$(name)" ]; then echo "Error: Please provide a migration name (e.g., make migrate-diff name=add_user)"; exit 1; fi
	atlas migrate diff add_user \
	--dir "file://grpc_boilerplate_db/migrate/migrations" \
	--to "ent://ent/schema" \
	--dev-url "docker://postgres/15/test?search_path=public"

.PHONY: help
# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help