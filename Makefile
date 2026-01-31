# Configuration
PROJECT  = main
OUT_DIR  = build
# Find all subdirectories containing .tex files to mirror them in OUT_DIR
TEX_DIRS = $(shell find . -type d -not -path "./$(OUT_DIR)*" -not -path "./.*")

# Programs
LATEX    = pdflatex
BIBTEX   = bibtex
FLAGS    = -interaction=nonstopmode -halt-on-error -output-directory=$(OUT_DIR)

.PHONY: all clean setup

all: setup $(OUT_DIR)/$(PROJECT).pdf ## Build the full document

setup: ## Create output directory and all necessary subfolders
	@mkdir -p $(OUT_DIR)
	@$(foreach dir,$(TEX_DIRS),mkdir -p $(OUT_DIR)/$(dir);)

$(OUT_DIR)/$(PROJECT).pdf: $(PROJECT).tex $(shell find . -name "*.tex")
	@echo "--- Pass 1 ---"
	$(LATEX) $(FLAGS) $(PROJECT).tex
	@echo "--- Bibliography ---"
	-$(BIBTEX) $(OUT_DIR)/$(PROJECT)
	@echo "--- Pass 2 ---"
	$(LATEX) $(FLAGS) $(PROJECT).tex
	@echo "--- Pass 3 ---"
	$(LATEX) $(FLAGS) $(PROJECT).tex
	@echo "Success! PDF: $(OUT_DIR)/$(PROJECT).pdf"

clean: ## Complete wipe of build files
	rm -rf $(OUT_DIR)