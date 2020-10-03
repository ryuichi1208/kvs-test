.PHONY: restart
restart: version
	@docker-compose restart;

.PHONY: rebuild
rebuild: version
	@docker-compose down --rmi all ; \
		docker-compose up -d ; \

.PHONY: version
version:
	@docker-compose version
