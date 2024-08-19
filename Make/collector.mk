# =============================================================================
# TARGETS
# =============================================================================

#### Collector
collector-up: .logo ## Starts the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},up -d --remove-orphans)

collector-down: .logo ## Shuts down the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},down -v)

collector-status: .logo ## Show the status of the collectors
	$(call SERVICE_STATUS,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS})

collector-logs: .logo ## Show logs from the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},logs -f)

collector-open: .logo ## Open the collector in the browser
	@echo -e "${H2BEGIN}Open the collector in the browser${H2END}"
	@echo -e "${PBEGIN}open http://0.0.0.0:16686${PEND}\n"
	@open http://0.0.0.0:16686

# =============================================================================
# TARGET ALIASES
# =============================================================================

clog: collector-logs
cps: collector-status
cst: collector-status
csh: collector-bash
collector-ps: collector-status

