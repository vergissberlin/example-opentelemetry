# =============================================================================
# TARGETS
# =============================================================================

#### Collector
collector-up: .logo ## Starts the collectors
	@make .setup
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},up -d --remove-orphans)

collector-down: .logo ## Shuts down the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},down -v)

collector-ps: .logo ## Show the status of the collectors
	$(call SERVICE_STATUS,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS})

collector-logs: .logo ## Show logs from the collectors
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},logs -f)

# =============================================================================
# TARGET ALIASES
# =============================================================================

clog: collector-logs
cps: collector-status
cst: collector-status
csh: collector-bash
collector-status: collector-ps

