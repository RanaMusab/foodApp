# Variables
FLUTTER=flutter
HYGENMOBILE=hygen generator mobile

# Help command
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make get         - Install dependencies"
	@echo "  make clean       - Clean the project"
	@echo "  make run         - Run the app on a connected device"
	@echo "  make build-apk   - Build APK for release"
	@echo "  make build-appbundle - Build AppBundle for release"
	@echo "  make build-ios   - Build iOS release"
	@echo "  make analyze     - Analyze the code for errors"
	@echo "  make test        - Run all Flutter tests"
	@echo "  make format      - Format the Dart code"
	@echo "  make flavors     - Run app with specific flavors"
	@echo "  make release     - Prepare app for release"
	@echo "  make doctor      - Run Flutter doctor for troubleshooting"
	@echo "  make upgrade     - Upgrade Flutter dependencies"
	@echo "  make create-module name=<ModuleName>  - Generate a module dynamically"

# Install dependencies
.PHONY: get
get:
	$(FLUTTER) pub get

# Clean project
.PHONY: clean
clean:
	$(FLUTTER) clean

# Run the app
.PHONY: run
run:
	$(FLUTTER) run

# Build Android APK
.PHONY: build-apk
build-apk:
	$(FLUTTER) build apk --release

# Build Android AppBundle
.PHONY: build-appbundle
build-appbundle:
	$(FLUTTER) build appbundle

# Build iOS app
.PHONY: build-ios
build-ios:
	$(FLUTTER) build ios --release --no-codesign

# Analyze code
.PHONY: analyze
analyze:
	$(FLUTTER) analyze

# Run tests
.PHONY: test
test:
	$(FLUTTER) test

# Format Dart code
.PHONY: format
format:
	dart format .

# Run app with specific flavors
.PHONY: flavors
flavors:
	@echo "Usage: make run-dev / make run-staging / make run-prod"

.PHONY: run-dev
run-dev:
	$(FLUTTER) run --flavor dev --target lib/main_dev.dart

.PHONY: run-staging
run-staging:
	$(FLUTTER) run --flavor staging --target lib/main_staging.dart

.PHONY: run-prod
run-prod:
	$(FLUTTER) run --flavor prod --target lib/main_prod.dart

# Prepare for release
.PHONY: release
release:
	make clean
	make get
	make analyze
	make format
	make build-appbundle
	make build-ios

# Run Flutter Doctor
.PHONY: doctor
doctor:
	$(FLUTTER) doctor

# Upgrade dependencies
.PHONY: upgrade
upgrade:
	$(FLUTTER) pub upgrade


# Generate modules using Hygen with a dynamic name
.PHONY: create-module
create-module:
	@if [ -z "$(name)" ]; then \
		echo "❌ Error: Please provide a module name using name=<ModuleName>"; \
		exit 1; \
	fi
	$(HYGENMOBILE) $(name)
