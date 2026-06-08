.PHONY: generate clean setup

# Ensure protoc plugins are on PATH
export PATH := $(HOME)/go/bin:$(PATH)

PROTO_DIR := .
PROTO_FILE := gateway/control/v1/control.proto
GO_OUT := .

generate:
	protoc \
		--proto_path=$(PROTO_DIR) \
		--go_out=$(GO_OUT) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT) \
		--go-grpc_opt=paths=source_relative \
		$(PROTO_FILE)

clean:
	rm -f gateway/control/v1/control.pb.go gateway/control/v1/control_grpc.pb.go

setup:
	cp scripts/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✓ pre-commit hook installed"