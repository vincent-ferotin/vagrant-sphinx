# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS      ?=
SPHINXBUILD     ?= sphinx-build
SOURCEDIR       = src
BUILDDIR        = .
LATEX_OUTPUTDIR = latex
LATEX_MAKEFILE  = Makefile
LATEXOPTS       = -lualatex --interaction=nonstopmode

# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
# See https://stackoverflow.com/questions/5377297/how-to-manually-call-another-target-from-a-make-target
THIS_MAKEFILE  := $(abspath $(lastword $(MAKEFILE_LIST)))

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo ""
	@echo "***********************************"
	@echo "** Particularités de ce Makefile **"
	@echo "***********************************"
	@echo ""
	@echo "Seules les cibles suivantes sont disponibles pour le présent projet:"
	@echo "  clean"
	@echo "  html"
	@echo "  pdf"
	@echo "  all"
	@echo ""

.PHONY: help clean html pdf all Makefile

clean: Makefile
	@rm -Rf doctrees html latex
	@mkdir doctrees html latex
	@touch doctrees/.gitkeep html/.gitkeep latex/.gitkeep

# $(O) is meant as a shortcut for $(SPHINXOPTS).
html: Makefile
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# $(O) is meant as a shortcut for $(SPHINXOPTS).
pdf: Makefile
	@$(SPHINXBUILD) -b latex "$(SOURCEDIR)" "$(BUILDDIR)/$(LATEX_OUTPUTDIR)" $(SPHINXOPTS) $(O)
	@cd $(LATEX_OUTPUTDIR) && $(MAKE) -f $(LATEX_MAKEFILE) all-pdf LATEXOPTS="$(LATEXOPTS)"

# See https://stackoverflow.com/questions/5377297/how-to-manually-call-another-target-from-a-make-target
# for recursive call of Makefile
all: Makefile
	 @$(MAKE) -f $(THIS_MAKEFILE) clean
	 @$(MAKE) -f $(THIS_MAKEFILE) html
	 @$(MAKE) -f $(THIS_MAKEFILE) pdf

