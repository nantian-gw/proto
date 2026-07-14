# Nantian Gateway — Proto

Shared protobuf contract between the Go control plane and Rust data plane.

## Schema

- `gateway/control/v1/control.proto` — xDS configuration snapshot, service definitions, and message types

## Module Path

```
github.com/nantian-gw/proto
```

Generated Go files live under `gateway/control/v1/` (source-relative output per `buf.gen.yaml`).
This repository is a valid Go module with `go.mod` and `go.sum` checked in.

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

---

## Publishing a Release

The module path is `github.com/nantian-gw/proto`. Go module resolution uses Git tags,
so publishing is a single step:

```bash
# Tag the release (use semver-compatible calendar versioning: vYYYY.MM.PATCH)
git tag v2026.07.0

# Push the tag — Go tools will discover it via the module proxy
git push origin v2026.07.0
```

**Tag naming rules:**
- Must follow Go module tag convention: `v<major>.<minor>.<patch>` (pre-release suffix allowed, e.g. `v2026.07.0-rc1`)
- Calendar-style versions like `v2026.07.0` are valid semver and work with Go modules
- Existing pre-release tags: `v2026.06.0-rc1` through `v2026.06.0-rc4`

**Before tagging a final release:**
```bash
make verify   # lint proto + regenerate + check no dirty files
git diff --stat HEAD   # confirm nothing uncommitted
```

---

## Consuming from Gateway (Control Plane)

The gateway currently uses a **local `replace` directive** pointing to a stale copy:

```
replace github.com/nantian-gw/proto => ./gen/go
```

To switch to the published module:

### 1. Remove the `replace` directive

Delete this line from `gateway/go.mod`:
```
replace github.com/nantian-gw/proto => ./gen/go
```

### 2. Pin to a published version

```bash
cd /root/nantian-gw/gateway
go get github.com/nantian-gw/proto@v2026.07.0
go mod tidy
```

This updates the `require` block to:
```
require github.com/nantian-gw/proto v2026.07.0
```

### 3. Clean up the stale copy (optional)

```bash
rm -rf /root/nantian-gw/gateway/gen/go
```

The `gen/go/` directory in gateway is a snapshot that predates the standalone proto
module. It is no longer needed once the published module is consumed.

### 4. Verify

```bash
cd /root/nantian-gw/gateway
go build ./...
```

### Local development shortcut

During development, you can use a `replace` that points to the live proto worktree
instead of the gateway-local copy:

```
replace github.com/nantian-gw/proto => ../proto
```

This avoids requiring a published tag for every proto change.

---

## Vanity Import Path (Optional)

To serve the module at `go.nantian.dev/proto` instead of `github.com/nantian-gw/proto`:

1. **Set up the vanity server**: Serve an HTML meta tag at
   `https://go.nantian.dev/proto?go-get=1`:
   ```html
   <meta name="go-import"
         content="go.nantian.dev/proto git https://github.com/nantian-gw/proto.git">
   ```

2. **Update the `go.mod` module path** to `go.nantian.dev/proto` and update all
   `import` paths in the repository.

3. **Tag and push** — Go clients can then `go get go.nantian.dev/proto@v2026.07.0`.

This is entirely optional. `github.com/nantian-gw/proto` works without any
infrastructure.

---

## Versioning

This repository follows [Semantic Versioning](https://semver.org). Breaking changes
to the proto schema require a major version bump.

Use calendar-based tags: `vYYYY.MM.PATCH` (e.g., `v2026.07.0`).

## Generation

Install the [Buf CLI](https://buf.build/docs/installation), then run:

```bash
buf lint
buf generate
```

`make generate` is a wrapper around `buf generate`. Generated Go files are
checked in so Go consumers can import this module directly.

Before changing `.proto` files, run:

```bash
make verify
```

## License

Apache 2.0 — see [LICENSE](LICENSE)
