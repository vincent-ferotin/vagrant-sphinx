# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS          ?=
SPHINXBUILD         ?= sphinx-build
SOURCEDIR            = src
BUILDDIR             = .
DOCTREESDIR          = doctrees
HTMLDIR              = html
LATEXDIR             = latex
LATEXOPTS            = --interaction=nonstopmode
LATEXMKOPTS         ?=
LATEXMAKEFILETARGET  =  # default to `all`: `all-pdf`

# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
# See https://stackoverflow.com/questions/5377297/how-to-manually-call-another-target-from-a-make-target
THIS_MAKEFILE  := $(abspath $(lastword $(MAKEFILE_LIST)))

# Put it first so that "make" without argument is like "make help".
help:
	@echo ""
	@echo "Utilisez SVP ce Makefile via la commande \`make TARGET', où TARGET est une de cibles suivantes:"
	@echo "  clean - Supprime tous les fichiers générés précédemment par Sphinx."
	@echo "  html  - Génère la documentation sous forme d'un site HTML statique."
	@echo "  pdf   - Génère la documentation sous forme d'un ou plusieurs fichiers PDF."
	@echo "  all   - Génère la documentation sous tous les formats ci-dessus (actuellement: HTML et PDF)."
	@echo ""

.PHONY: help clean html pdf all Makefile

clean: Makefile
	@rm -Rf $(DOCTREESDIR) $(HTMLDIR) $(LATEXDIR)
	@mkdir $(DOCTREESDIR) $(HTMLDIR) $(LATEXDIR)
	@touch $(DOCTREESDIR)/.gitkeep $(HTMLDIR)/.gitkeep $(LATEXDIR)/.gitkeep

# $(O) is meant as a shortcut for $(SPHINXOPTS).
html: Makefile
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# $(O) is meant as a shortcut for $(SPHINXOPTS).
pdf: Makefile
	# Sphinx default for `latexpdf` target:
	#@$(SPHINXBUILD) -M latexpdf "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@$(SPHINXBUILD) -b latex "$(SOURCEDIR)" "$(BUILDDIR)/$(LATEXDIR)" $(SPHINXOPTS) $(O)
	@cd $(LATEXDIR) && $(MAKE) $(LATEXMAKEFILETARGET) LATEXOPTS="$(LATEXOPTS)" LATEXMKOPTS="$(LATEXMKOPTS)"

# See https://stackoverflow.com/questions/5377297/how-to-manually-call-another-target-from-a-make-target
# for recursive call of Makefile
all: Makefile
	 @$(MAKE) -f $(THIS_MAKEFILE) clean
	 @$(MAKE) -f $(THIS_MAKEFILE) html
	 @$(MAKE) -f $(THIS_MAKEFILE) pdf

