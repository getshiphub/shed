.DEFAULT_GOAL = build
SHED = ./shed

# Get all dependencies
setup:
	@go mod download
# Self-hoisted!
	@$(SHED) install
	@$(SHED) run go-fish install
.PHONY: setup

# Build shed
build:
	@go build
	@go run build/main.go
.PHONY: build

# Clean all build artifacts
clean:
	@rm -rf dist
	@rm -rf coverage
	@rm -f shed
.PHONY: clean

# Run the linter
lint:
	@$(SHED) run golangci-lint run ./...
.PHONY: lint

# Remove version installed with go install
go-uninstall:
	@rm $(shell go env GOPATH)/bin/shed
.PHONY: go-uninstall

# Run tests and collect coverage data
test:
	@mkdir -p coverage
	@go test -coverpkg=./... -coverprofile=coverage/coverage.txt ./...
	@go tool cover -html=coverage/coverage.txt -o coverage/coverage.html
.PHONY: test

# Run tests and print coverage data to stdout
test-ci:
	@mkdir -p coverage
	@go test -coverpkg=./... -coverprofile=coverage/coverage.txt ./...
	@go tool cover -func=coverage/coverage.txt
.PHONY: test-ci
