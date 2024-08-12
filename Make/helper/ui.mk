
# =============================================================================
# Variables
# =============================================================================

# Styles
H1BEGIN := $(FDIM)\n──────────────────────────────────────────────────────────────────────────\n$(FRESET)$(FCYAN) ⁜ $(FRESET) $(FBOLD)
H1END := $(FRESET)$(FDIM)\n──────────────────────────────────────────────────────────────────────────$(FRESET)


H2BEGIN := $(FDIM)\n──────────────────────────────────────────────────────────────────────────\n$(FRESET)$(FCYAN) ⁜ $(FRESET) $(FBOLD)
H2END := $(FRESET)

PBEGIN := $(FDIM) ▸  $(FRESET)
PEND := $(FDIM)$(FRESET)
P_SUCCESS_BEGIN := $(FGREEN)
P_SUCCESS_END := $(FRESET)
P_WARNING_BEGIN := $(FRED)
P_WARNING_END := $(FRESET)

MSG_SUCCESS_BEGIN := $(FGREEN) ⁜ $(FRESET)$(FBOLD)
MSG_SUCCESS_END := $(FRESET)
MSG_WARNING_BEGIN := $(FRED) ⁜ $(FRESET)$(FBOLD)
MSG_WARNING_END := $(FRESET)


# =============================================================================
# TARGETS
# =============================================================================

.logo:
	@echo -e "\n${FDIM}::${FRESET} ${FCYAN}think${FRESET}${FYELLOW}port${FRESET} ${FDIM}:: ${PROJECT_NAME} $$( git describe --tags `git rev-list --tags --max-count=1` )${FRESET}"

.header:
	@echo -e "$(H1BEGIN)$(ARGS)$(H1END)"



