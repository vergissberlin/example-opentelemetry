# =============================================================================
# TARGETS
# =============================================================================


help: .logo
	@echo -e "${H1BEGIN}Available targets${H1END}"
	@echo -e "${FDIM}Run ${FRESET}make <TARGET> <ARGUMENTS>${FDIM} to call the targets.${FRESET}\n"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -E 's/#### /\n${FCYAN}⁜${FRESET} ${FBOLD}Target-Group ${FRESET}/g' | column -t -s '##' | sed -e 's/://g'| sed -e 's/⁜/\n⁜/g' | sed -e 's/\ \.logo//g'
	@echo ""
