.PHONY: generate lint breaking verify clean setup

BUF_BREAKING_AGAINST ?= .git#branch=main

generate:
	buf generate

lint:
	buf lint

breaking:
	buf breaking --against "$(BUF_BREAKING_AGAINST)"

verify: lint generate
	git diff --exit-code gateway/control/v1/control.pb.go gateway/control/v1/control_grpc.pb.go

clean:
	rm -f gateway/control/v1/control.pb.go gateway/control/v1/control_grpc.pb.go

setup:
	cp scripts/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✓ pre-commit hook installed"
