# Nantian Gateway — Proto

Shared protobuf contract between the Go control plane and Rust data plane.

## Schema

- `gateway/control/v1/control.proto` — xDS configuration snapshot, service definitions, and message types

## Usage

### Go

```go
import controlv1 "github.com/nantian-gw/proto/gateway/control/v1"
```

### Rust

```toml
[dependencies]
nantian-proto = { git = "https://github.com/nantian-gw/proto.git" }
```

## Versioning

This repository follows [Semantic Versioning](https://semver.org). Breaking changes to the proto schema require a major version bump.

## Generation

```bash
buf generate
```

## License

Apache 2.0 — see [LICENSE](LICENSE)