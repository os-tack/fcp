# FCP — Multi-Repo Development Workflow
#
# This Makefile lives in the root fcp/ directory and coordinates
# local development across fcp-core, fcp-drawio, fcp-terraform, and fcp-midi.
#
# Key commands:
#   make setup    — Install deps, create npm links, configure git hooks
#   make link     — Link local fcp-core into consumer repos
#   make unlink   — Restore registry versions
#   make test     — Test all projects
#   make status   — Git + link status across all repos

CORE_TS   = fcp-core/typescript
DRAWIO    = fcp-drawio
TERRAFORM = fcp-terraform
CORE_PY   = fcp-core/python
MIDI      = fcp-midi

CONSUMERS = $(DRAWIO) $(TERRAFORM)

.PHONY: setup link unlink build build-core build-drawio build-terraform \
        test test-core-ts test-core-py test-drawio test-terraform test-midi \
        link-py unlink-py status check-refs watch-core help

# ─── Setup ───────────────────────────────────────────────────────────

setup: ## Install all deps, create npm links, configure git hooks
	@echo "==> Installing fcp-core (TypeScript)..."
	cd $(CORE_TS) && npm install
	@echo "==> Installing fcp-drawio..."
	cd $(DRAWIO) && npm install
	@echo "==> Installing fcp-terraform..."
	cd $(TERRAFORM) && npm install
	@echo "==> Creating npm links..."
	$(MAKE) link
	@echo "==> Configuring git hooks..."
	@for repo in $(CONSUMERS); do \
		if [ -d "$$repo/.githooks" ]; then \
			cd $$repo && git config core.hooksPath .githooks && cd ..; \
			echo "    $$repo: hooks configured"; \
		fi; \
	done
	@echo "==> Setup complete."

# ─── Linking ─────────────────────────────────────────────────────────

link: build-core ## Build fcp-core, npm link globally, link into consumers
	@echo "==> Registering @aetherwing/fcp-core globally..."
	cd $(CORE_TS) && npm link
	@for repo in $(CONSUMERS); do \
		echo "==> Linking into $$repo..."; \
		cd $$repo && npm link @aetherwing/fcp-core && cd ..; \
	done
	@echo "==> Links active. Run 'make link' again after any 'npm install'."

unlink: ## Remove links, restore registry versions
	@for repo in $(CONSUMERS); do \
		echo "==> Unlinking in $$repo..."; \
		cd $$repo && npm unlink @aetherwing/fcp-core && npm install && cd ..; \
	done
	@echo "==> Links removed. Using registry versions."

# ─── Building ────────────────────────────────────────────────────────

build: build-core build-drawio build-terraform ## Build all TS projects (core first)

build-core: ## Build fcp-core TypeScript
	cd $(CORE_TS) && npm run build

build-drawio: ## Build fcp-drawio
	cd $(DRAWIO) && npm run build

build-terraform: ## Build fcp-terraform
	cd $(TERRAFORM) && npm run build

# ─── Testing ─────────────────────────────────────────────────────────

test: test-core-ts test-core-py test-drawio test-terraform test-midi ## Test all projects

test-core-ts: ## Test fcp-core TypeScript
	cd $(CORE_TS) && npm test

test-core-py: ## Test fcp-core Python
	cd $(CORE_PY) && uv run pytest

test-drawio: ## Test fcp-drawio
	cd $(DRAWIO) && npm test

test-terraform: ## Test fcp-terraform
	cd $(TERRAFORM) && npm test

test-midi: ## Test fcp-midi
	cd $(MIDI) && uv run pytest

# ─── Python Linking ──────────────────────────────────────────────────

link-py: ## Editable install of fcp-core Python for fcp-midi
	cd $(MIDI) && uv pip install -e ../$(CORE_PY)
	@echo "==> fcp-core Python linked into fcp-midi."

unlink-py: ## Remove editable install, restore published version
	cd $(MIDI) && uv pip install fcp-core
	@echo "==> fcp-core Python restored to published version."

# ─── Utilities ───────────────────────────────────────────────────────

status: ## Git status + link status across all repos
	@echo "=== Git Status ==="
	@for repo in $(CORE_TS)/.. $(DRAWIO) $(TERRAFORM) $(MIDI); do \
		echo ""; \
		echo "--- $$repo ---"; \
		cd $$repo && git status -sb && cd $(CURDIR); \
	done
	@echo ""
	@echo "=== npm Link Status ==="
	@for repo in $(CONSUMERS); do \
		echo ""; \
		echo "--- $$repo ---"; \
		if [ -L "$$repo/node_modules/@aetherwing/fcp-core" ]; then \
			echo "  @aetherwing/fcp-core -> $$(readlink $$repo/node_modules/@aetherwing/fcp-core)"; \
		else \
			echo "  @aetherwing/fcp-core: registry (not linked)"; \
		fi; \
	done

check-refs: ## Verify no file: references in any package.json
	@echo "Checking for file: references..."
	@found=0; \
	for f in $(CORE_TS)/package.json $(DRAWIO)/package.json $(TERRAFORM)/package.json; do \
		if grep -q '"file:' "$$f"; then \
			echo "  FAIL: $$f contains a file: reference"; \
			found=1; \
		fi; \
	done; \
	if [ $$found -eq 0 ]; then \
		echo "  All clean."; \
	else \
		exit 1; \
	fi

watch-core: ## tsc --watch for fcp-core during active dev
	cd $(CORE_TS) && npx tsc --watch

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
