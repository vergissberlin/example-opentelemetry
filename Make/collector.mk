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

#### Collectors (datadog, opentelemetry, opentelemetry-contrib)
collector-%-up: .logo ## Starts the emitter in the specified language
	@make .setup
	@echo -e "${H2BEGIN}Run collector with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_COLLECTORS}/$*/compose.yml up
	 -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_COLLECTORS}/$*/compose.yml up -d --build


# =============================================================================
# TARGET ALIASES
# =============================================================================

clog: collectors-logs
cps: collector-status
cst: collector-status
csh: collector-bash
collector-status: collectors-ps

