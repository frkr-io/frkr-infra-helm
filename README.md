# frkr-helm

Helm charts for deploying the Traffic Mirroring Platform to Kubernetes.

## Purpose

This repository contains Helm charts for deploying frkr services to Kubernetes, including:
- Ingest Gateway
- Streaming Gateway
- Operator
- Envoy ingress
- Optional: CockroachDB, Redpanda (for full stack deployment)

## Structure

```
frkr-helm/
├── Chart.yaml
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

## Quick Start

### Full Stack (includes CockroachDB and Redpanda)

```bash
helm install frkr ./frkr-helm -f values-full.yaml
```

### BYO Data Plane

```bash
helm install frkr ./frkr-helm -f values-byo.yaml
```

## Configuration

See `values.yaml` for all configuration options.

## License

Apache 2.0

