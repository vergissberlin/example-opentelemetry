# =============================================================================
# TARGETS
# =============================================================================

#### Receivers (aspire, grafana, jaeger, …)
receiver-%-up: .logo ## Starts the receiver in the specified language
	@make .setup
	@echo -e "${H2BEGIN}Run receiver with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_RECEIVERS}/$*/compose.yml up -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_RECEIVERS}/$*/compose.yml up -d --build

receiver-%-restart: .logo ## Restarts the receiver in the specified language
	@echo -e "${H2BEGIN}Restart receiver with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_RECEIVERS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_RECEIVERS}/$*/compose.yml down -v
	@echo -e "${PBEGIN}docker compose -f ${PATH_RECEIVERS}/$*/compose.yml up -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_RECEIVERS}/$*/compose.yml up -d

receiver-%-down: .logo ## Stops the receiver in the specified language
	@echo -e "${H2BEGIN}Stop receiver with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_RECEIVERS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_RECEIVERS}/$*/compose.yml down -v

receiver-%-ps: .logo ## Show the status of the receiver in the specified language
	@echo -e "${H2BEGIN}Receiver status of ${*}${H2END}\n"
	@docker compose -f ${PATH_RECEIVERS}/$*/compose.yml ps

receiver-%-logs: .logo ## Show logs from the receiver in the specified language
	@echo -e "${H2BEGIN}Receiver logs of ${*}${H2END}\n"
	docker compose -f ${PATH_RECEIVERS}/$*/compose.yml logs -f


# =============================================================================
# TARGET ALIASES
# =============================================================================

receiver-%-start: receiver-%-up
receiver-%-status: receiver-%-ps

