
# >> Just understand train station? <<
# @see https://gist.githubusercontent.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9/raw/a1f52d598f0749437427a6413d100c3f0e9fd219/Makefile

# =============================================================================
# Variables
# =============================================================================

# Define standard colors
ifneq (,$(findstring xterm,${TERM}))
	FBOLD         := $(shell tput bold)
	FDIM          := $(shell tput dim)
	FRESET        := $(shell tput -Txterm sgr0)

	FBLACK        := $(shell tput -Txterm setaf 0)
	FRED          := $(shell tput -Txterm setaf 1)
	FGREEN        := $(shell tput -Txterm setaf 2)
	FYELLOW       := $(shell tput -Txterm setaf 3)
	FBLUE         := $(shell tput -Txterm setaf 4)
	FPURPLE       := $(shell tput -Txterm setaf 5)
	FCYAN         := $(shell tput -Txterm setaf 6)
	FWHITE        := $(shell tput -Txterm setaf 7)
else
	FBOLD         := ""
	FDIM          := ""
	FRESET        := ""

	FBLACK        := ""
	FRED          := ""
	FGREEN        := ""
	FYELLOW       := ""
	FBLUE          := ""
	FPURPLE       := ""
	FCYAN         := ""
	FWHITE        := ""
	FRESET        := ""
endif


# Set target color
TARGET_COLOR := $(CYAN)



# =============================================================================
# TARGETS
# =============================================================================

colors: logo
	@echo "${FBLACK}BLACK${FRESET}"
	@echo "${FRED}RED${FRESET}"
	@echo "${FGREEN}GREEN${FRESET}"
	@echo "${FYELLOW}YELLOW${FRESET}"
	@echo "${FBLUE}BLUE${FRESET}"
	@echo "${FPURPLE}PURPLE${FRESET}"
	@echo "${FCYAN}BLUE${FRESET}"
	@echo "${FWHITE}WHITE${FRESET}"
	@echo "${FBOLD}BOLD${FRESET}"
	@echo "${FDIM}DIM${FRESET}"
