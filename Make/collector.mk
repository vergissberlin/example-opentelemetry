COLLECTOR_COMPOSE_FILE=-f iac/docker/compose.yml

# =============================================================================
# TARGETS
# =============================================================================

#### Collector
collector-up: .logo ## Starts the opentelemetry collector
	 docker compose ${COLLECTOR_COMPOSE_FILE} up -d

collector-down: .logo ## Starts the opentelemetry collector
	 docker compose ${COLLECTOR_COMPOSE_FILE} down -v

collector-status: .logo ## Show running containers
	@docker compose ${COLLECTOR_COMPOSE_FILE} ps

collector-logs: .logo ## Show logs from containers
	 docker compose ${COLLECTOR_COMPOSE_FILE} logs -f

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

