SHELL = /bin/bash

# >> Just understand train station? <<
# @see https://makefiletutorial.com/#the-all-target
# @see https://pawamoy.github.io/posts/pass-makefile-args-as-typed-in-command-line/

# =============================================================================
# VARIABLES
# =============================================================================

ARGS = $(filter-out $@,$(MAKECMDGOALS))
TARGETS = $(filter-out $(MAKECMDGOALS),$@)

PATH_EMITTERS=examples/emitters
PATH_COLLECTORS=examples/collectors
PATH_EXPORTERS=examples/exporters
PATH_RECEIVERS=examples/receivers

LIST_EMITTERS=dart nodejs python
LIST_COLLECTORS=datadog-agent opentelemetry opentelemetry-contrib
LIST_PROCESSORS=
LIST_EXPORTERS=
LIST_RECEIVERS=aspire grafana jaeger prometheus

# =============================================================================
# TARGETS
# ==========================================================================

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
			docker compose -f ${3}/$${item}/compose.yml ps --format "table \
				{{printf \"%-12s\" .ID}} \
				{{printf \"%-42s\" .Name}} \
				{{printf \"%-10s\" .State}} \
				{{if gt (len .Publishers) 0}}{{with index .Publishers 0}}{{printf \"http://0.0.0.0:%d\" .PublishedPort}}{{end}}{{else}}No published ports{{end}}"; \
		fi; \
		if [ $$(docker compose -f ${3}/$${item}/compose.yml ps --services  --status exited --status paused --status restarting --status removing --status dead --status exited | wc -l) -gt 0 ]; then \
			echo -e "${P_WARNING_BEGIN}"; \
			docker compose -f ${3}/$${item}/compose.yml ps --format "table \
				{{printf \"%-12s\" .ID}}  \
				{{printf \"%-42s\" .Name}}  \
				{{printf \"%-10s\" .State}} " \
				--status exited \
				--status paused \
				--status restarting \
				--status removing \
				--status dead \
				--status exited]; \
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
