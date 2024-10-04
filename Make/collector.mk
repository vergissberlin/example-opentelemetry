# =============================================================================
# TARGETS
# =============================================================================

#### Collector (all)
collectors-up: .logo ## Starts the collectors
	@make .setup
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},up -d --remove-orphans)

collectors-down: .logo ## Shuts down the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},down -v)

collectors-ps: .logo ## Show the status of the collectors
	$(call SERVICE_STATUS,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS})

collectors-logs: .logo ## Show logs from the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},logs -f)

#### Collectors (datadog-agent, opentelemetry, opentelemetry-contrib)
collector-%-up: .logo ## Starts the collector in the specified language
	@make .setup
	@echo -e "${H2BEGIN}Run collector with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_COLLECTORS}/$*/compose.yml up	 -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_COLLECTORS}/$*/compose.yml up -d --build

collector-%-restart: .logo ## Restarts the collector in the specified language
	@echo -e "${H2BEGIN}Restart collector with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_COLLECTORS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_COLLECTORS}/$*/compose.yml down -v
	@echo -e "${PBEGIN}docker compose -f ${PATH_COLLECTORS}/$*/compose.yml up -d --build --remove-orphans${PEND}\n"
	@docker comp

collector-%-down: .logo ## Stops the collector in the specified language
	@echo -e "${H2BEGIN}Stop collector with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_COLLECTORS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_COLLECTORS}/$*/compose.yml down -v

collector-%-ps: .logo ## Show the status of the collector in the specified language
	@echo -e "${H2BEGIN}Collector status of ${*}${H2END}\n"
	@docker compose -f ${PATH_COLLECTORS}/$*/compose.yml ps

collector-%-logs: .logo ## Show logs from the collector in the specified language
	@echo -e "${H2BEGIN}Collector logs of ${*}${H2END}\n"
	docker compose -f ${PATH_COLLECTORS}/$*/compose.yml logs -f

# =============================================================================
# TARGET ALIASES
# =============================================================================

clog: collectors-logs
cps: collector-status
cst: collector-status
csh: collector-bash
collector-status: collectors-ps

