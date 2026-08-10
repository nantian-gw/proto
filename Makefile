.PHONY: generate lint breaking verify clean setup

BUF_BREAKING_AGAINST ?= .git#branch=main

generate:
	buf generate
	# Remove umbrella file generated code (duplicates domain file registrations)
	rm -f gateway/control/v1/control.pb.go gateway/control/v1/control_grpc.pb.go

lint:
	buf lint

breaking:
	buf breaking --against "$(BUF_BREAKING_AGAINST)"

verify: lint generate
	# Verify all generated .pb.go files are in sync (except umbrella duplicates)
	git diff --exit-code gateway/control/v1/
	@test ! -f gateway/control/v1/control.pb.go && echo "✓ umbrella control.pb.go removed after generate" || (echo "✗ control.pb.go should not exist"; exit 1)
	@test ! -f gateway/control/v1/control_grpc.pb.go && echo "✓ umbrella control_grpc.pb.go removed after generate" || (echo "✗ control_grpc.pb.go should not exist"; exit 1)

clean:
	rm -f \
		gateway/control/v1/ai.pb.go \
		gateway/control/v1/config.pb.go \
		gateway/control/v1/control.pb.go \
		gateway/control/v1/control_grpc.pb.go \
		gateway/control/v1/discovery.pb.go \
		gateway/control/v1/discovery_grpc.pb.go \
		gateway/control/v1/route_policy.pb.go \
		gateway/control/v1/wasm.pb.go

setup:
	cp scripts/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✓ pre-commit hook installed"
