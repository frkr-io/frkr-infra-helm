# frkr-infra-helm

Helm charts for deploying frkr to Kubernetes.

## Purpose

This repository contains Helm charts for deploying frkr services to Kubernetes, including:
- Ingest Gateway
- Streaming Gateway
- Operator
- Envoy ingress
- Optional: CockroachDB, Redpanda (for full stack deployment)

## Structure

```
frkr-infra-helm/
├── Chart.yaml
├── go.mod                  # Go module for resolving frkr-common dependency
├── values.yaml
├── values-full.yaml        # Full stack (includes CockroachDB/Redpanda)
├── values-byo.yaml         # BYO data plane
├── templates/
│   ├── ingress-gateway/    # Envoy ingress
│   ├── ingest-gateway/
│   ├── streaming-gateway/
│   ├── operator/
│   ├── cockroachdb/       # Optional included CockroachDB
│   └── redpanda/          # Optional included Redpanda
├── charts/                 # Chart dependencies
└── README.md
```

## Dependencies

This Helm chart uses `frkr-common` as a Go module dependency (via `go.mod`) to automatically sync database migrations. Migration files are synced from `frkr-common/migrations/` to `frkr-infra-helm/migrations/` before Helm deployment. The `migrations/` directory is git-ignored, ensuring migrations always come from the source of truth in `frkr-common`.

## Quick Start

> **Note:** For easiest deployment, use `frkrup` from `frkr-tools` which handles migration syncing automatically. See [frkr-tools K8S-QUICKSTART](https://github.com/frkr-io/frkr-tools/blob/master/K8S-QUICKSTART.md).

### Full Stack (includes CockroachDB and Redpanda)

**Before deploying, sync migrations:**
```bash
# Sync migrations from frkr-common (requires go.mod with frkr-common dependency)
cd frkr-infra-helm
COMMON_PATH=$(go list -m -f '{{.Dir}}' github.com/frkr-io/frkr-common 2>/dev/null) || COMMON_PATH=../frkr-common
mkdir -p migrations
cp $COMMON_PATH/migrations/*.up.sql migrations/
```

```bash
helm install frkr . -f values-full.yaml
```

### BYO Data Plane

**Before deploying, sync migrations:**
```bash
# Sync migrations from frkr-common (requires go.mod with frkr-common dependency)
cd frkr-infra-helm
COMMON_PATH=$(go list -m -f '{{.Dir}}' github.com/frkr-io/frkr-common 2>/dev/null) || COMMON_PATH=../frkr-common
mkdir -p migrations
cp $COMMON_PATH/migrations/*.up.sql migrations/
```

```bash
helm install frkr . -f values-byo.yaml
```

## Configuration

See `values.yaml` for all configuration options.

## License

Apache 2.0

