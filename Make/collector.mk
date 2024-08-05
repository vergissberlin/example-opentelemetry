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


# =============================================================================
# TARGET ALIASES
# =============================================================================

clog: collector-logs
cps: collector-status
cst: collector-status
csh: collector-bash

