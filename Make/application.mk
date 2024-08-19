
# =============================================================================
# TARGETS
# =============================================================================

#### Application
.setup:
	@echo -e "${H2BEGIN}Setup${H2END}"
	@echo -e "${PBEGIN}Create docker network if it is not allready exists${PEND}"
	@docker network create examples-opentelemetry-default 2>/dev/null || true

up: .logo ## Starts all collectors, emitters and receivers
	@make .setup
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},up -d --remove-orphans)
	$(call SERVICE_CONTROL,Emitters,${LIST_EMITTERS},${PATH_EMITTERS},up -d --remove-orphans)
	$(call SERVICE_CONTROL,Receivers,${LIST_RECEIVERS},${PATH_RECEIVERS},up -d --remove-orphans)

down: .logo ## Stops all collectors, emitters and receivers
	$(call SERVICE_CONTROL,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS},down -v)
	$(call SERVICE_CONTROL,Emitters,${LIST_EMITTERS},${PATH_EMITTERS},down -v)
	$(call SERVICE_CONTROL,Receivers,${LIST_RECEIVERS},${PATH_RECEIVERS},down -v)

ps: .logo ## Show running containers
	$(call SERVICE_STATUS,Collectors,${LIST_COLLECTORS},${PATH_COLLECTORS})
	$(call SERVICE_STATUS,Emitters,${LIST_EMITTERS},${PATH_EMITTERS})
	$(call SERVICE_STATUS,Receivers,${LIST_RECEIVERS},${PATH_RECEIVERS})

info: .logo ## Prints out project information
	@echo -e "${H1BEGIN}Project information${H1END}"
	@echo -e "${FBOLD}Project name:${FRESET}\t\t${COMPOSE_PROJECT_NAME}"
	@echo -e "${FBOLD}Repository origin:${FRESET}\t$$(git remote get-url origin)"
	@echo -e "${FBOLD}Current branch:${FRESET}\t\t$$( git branch --show-current )"
	@echo -e "${FBOLD}Latest tag:${FRESET}\t\t$$( git describe --tags `git rev-list --tags --max-count=1` )"

	@echo -e "${H1BEGIN}Repository statistics${H1END}"
	@echo -e "${FBOLD}Last commit message:${FRESET}\t$$( git log -1 --pretty=format:"%B" )"
	@echo -e "${FBOLD}Last commit date:${FRESET}\t$$( git log -1 --pretty=format:"%cd" )"
	@echo -e "${FBOLD}Last commit author:${FRESET}\t$$( git log -1 --pretty=format:"%an" ) <$$( git log -1 --pretty=format:"%ae" )>"
	@echo -e "${FBOLD}Last commit id:${FRESET}\t\t$$( git log -1 --pretty=format:"%H" )"
	@echo -e "${FBOLD}Count branches:${FRESET}\t $$( git branch -r | wc -l )"
	@echo -e "${FBOLD}Count tags:${FRESET}\t $$( git tag | wc -l )"
	@echo -e "${FBOLD}Count commits:${FRESET}\t\t$$( git rev-list --count HEAD )"

# =============================================================================
# TARGET ALIASES
# =============================================================================

log: logs
ps: status
st: status
sh: bash
start: up
