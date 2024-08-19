# =============================================================================
# TARGETS
# =============================================================================

#### Emitters (nodejs, python, go)
emitter-%-up: .logo ## Starts the emitter in the specified language
	@make .setup
	@echo -e "${H2BEGIN}Run emitter with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_EMITTERS}/$*/compose.yml up -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_EMITTERS}/$*/compose.yml up -d --build

emitter-%-restart: .logo ## Restarts the emitter in the specified language
	@echo -e "${H2BEGIN}Restart emitter with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_EMITTERS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_EMITTERS}/$*/compose.yml down -v
	@echo -e "${PBEGIN}docker compose -f ${PATH_EMITTERS}/$*/compose.yml up -d --build --remove-orphans${PEND}\n"
	@docker compose -f ${PATH_EMITTERS}/$*/compose.yml up -d

emitter-%-down: .logo ## Stops the emitter in the specified language
	@echo -e "${H2BEGIN}Stop emitter with ${*}${H2END}"
	@echo -e "${PBEGIN}docker compose -f ${PATH_EMITTERS}/$*/compose.yml down -v${PEND}\n"
	@docker compose -f ${PATH_EMITTERS}/$*/compose.yml down -v

emitter-%-ps: .logo ## Show the status of the emitter in the specified language
	@echo -e "${H2BEGIN}Emitter status of ${*}${H2END}\n"
	@docker compose -f ${PATH_EMITTERS}/$*/compose.yml ps

emitter-%-logs: .logo ## Show logs from the emitter in the specified language
	@echo -e "${H2BEGIN}Emitter logs of ${*}${H2END}\n"
	docker compose -f ${PATH_EMITTERS}/$*/compose.yml logs -f


# =============================================================================
# TARGET ALIASES
# =============================================================================

emitter-%-start: emitter-%-up
emitter-%-status: emitter-%-ps

