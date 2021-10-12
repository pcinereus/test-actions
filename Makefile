## Usage
## make website                     - all pages of the website
## make page                        - individual page
## make site                        - all pages
DOCS_DIR   := $(addprefix ,docs)
SRC        := $(foreach sdir, $(DOCS_DIR), $(wildcard $(sdir)/*.Rmd))
HTML_FILES := $(patsubst %.Rmd, %.html, $(SRC))

## Presentation files must not start with ReefCloud
PRES_MODULES := docs
PRES_SRC_DIR := $(addprefix ,$(PRES_MODULES))
# PRES_SRC     := $(foreach sdir, $(PRES_SRC_DIR), $(wildcard $(sdir)/*.Rmd))
PRES_SRC     := $(foreach sdir, $(PRES_SRC_DIR), $(wildcard $(sdir)/presentation*.Rmd))
## PRES_SRC     := $(patsubst 
PRES_FILES   := $(patsubst %.Rmd, %.html, $(PRES_SRC))

PANDOC     := pandoc
PANDOC_XELATEX_ARGS = --pdf-engine=xelatex

$(info $(DOCS_DIR))
$(info $(SRC))
$(info $(HTML_FILES))
$(info $(PRES_FILES))
$(info $(PRES_SRC))

objects := $(findstring ReefCloud, $(SRC))
## objects := $(wildcard docs/*.Rmd)
$(info $(objects))


page: $(HTML_FILES) $(SRC)

$(HTML_FILES): %.html: %.Rmd
	@echo 'Render page'
	@echo $<
	@echo $@
	echo "library(rmarkdown); render(\"$<\", output_format=\"bookdown::html_document2\", output_options=list(self_contained=TRUE), clean=FALSE)" | R --no-save --no-restore

site:
	@echo 'Render site'
	echo "library(rmarkdown); render_site(\"$(DOCS_DIR)\", output_format=\"html_document\")" | R --no-save --no-restore

pres: $(PRES_SRC) $(PRES_FILES)

$(PRES_FILES): %.html: %.Rmd
## ifneq (,$(findstring ReefCloud, $<))
	@echo $<
	@echo $@
	@echo $(notdir $@)
	#echo "library(rmarkdown); render(\"$<\", output_format=\"xaringan::moon_reader\", output_options=list(self_contained=TRUE))" | R --no-save --no-restore
	echo "library(rmarkdown); render(\"$<\", output_format=\"ioslides_presentation\", output_options=list(self_contained=TRUE))" | R --no-save --no-restore
## endif

.PHONY: tests

tests: 
	echo "library(testthat); test_dir('tests');" | R --no-save --no-restore
