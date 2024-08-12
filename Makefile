SHELL = /bin/bash

# >> Just understand train station? <<
# @see https://makefiletutorial.com/#the-all-target
# @see https://pawamoy.github.io/posts/pass-makefile-args-as-typed-in-command-line/

# =============================================================================
# VARIABLES
# =============================================================================

ARGS = $(filter-out $@,$(MAKECMDGOALS))
TARGETS = $(filter-out $(MAKECMDGOALS),$@)


PATH_COLLECTORS=examples/collectors
PATH_RECEIVERS=examples/receivers
PATH_EMITTERS=examples/emitters
PATH_EXPORTERS=examples/exporters

LIST_COLLECTORS=opentelemetry
LIST_EMITTERS=nodejs
LIST_RECEIVERS=prometheus
LIST_EXPORTERS=

# =============================================================================
# TARGETS
# =============================================================================

.PHONY: no_targets__ *
	no_targets__:

.DEFAULT_GOAL := help

# =============================================================================
# FUNCTIONS
# =============================================================================

define SERVICE_STATUS
	@echo -e "${H1BEGIN}${1}${H1END}"
	@for item in ${2}; do \
		if [ $$(docker compose -f ${3}/$${item}/compose.yml ps --services --status running | wc -l) -gt 0 ]; then \
			echo -e "${PBEGIN}Running ${1} in $${item}${PEND}"; \
			echo -e "${P_SUCCESS_BEGIN}"; \
			docker compose -f ${3}/$${item}/compose.yml ps --services --status running; \
			echo -e "${P_SUCCESS_END}"; \
		fi; \
		if [ $$(docker compose -f ${3}/$${item}/compose.yml ps --services  --status exited --status paused --status restarting --status removing --status dead --status exited | wc -l) -gt 0 ]; then \
			echo -e "${PBEGIN}Failing ${item} in $${item}${PEND}"; \
			echo -e "${P_WARNING_BEGIN}"; \
			docker compose -f ${3}/$${item}/compose.yml ps --services --status exited --status paused --status restarting --status removing --status dead --status exited]; \
			echo -e "${P_WARNING_END}"; \
		fi; \
	done
endef

define SERVICE_CONTROL
	@echo -e "${H1BEGIN}${1}${H1END}"
	@for item in ${2}; do \
		docker compose -f ${3}/$${item}/compose.yml ${4}; \
	done
endef



# =============================================================================
# INCLUDES
# =============================================================================

-include .env
-include make/*.mk
-include make/**/*.mk

# =============================================================================
# Argument fix workaround
# =============================================================================

%:
	@:
