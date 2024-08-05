SHELL = /bin/bash

# >> Just understand train station? <<
# @see https://makefiletutorial.com/#the-all-target
# @see https://pawamoy.github.io/posts/pass-makefile-args-as-typed-in-command-line/

# =============================================================================
# VARIABLES
# =============================================================================

ARGS = $(filter-out $@,$(MAKECMDGOALS))
TARGETS = $(filter-out $(MAKECMDGOALS),$@)



.PHONY: no_targets__ *
	no_targets__:

.DEFAULT_GOAL := help

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
