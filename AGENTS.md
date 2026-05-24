# AGENTS.md - Free OCI Kubernetes Cluster with GitOps

## Project Overview

Provisions a free Kubernetes cluster on OCI using OpenTofu + Flux CD GitOps. Deploys Cilium (Gateway API), cert-manager, monitoring (Prometheus/Loki/Grafana), and optional apps (WordPress, Paperless, MariaDB, Mealie, WireGuard).

## Required Tools

- **tofu** (OpenTofu), **flux**, **sops**, **gpg**, **oci** CLI, **kubectl**, **helm**

## Project Structure

```
tf/                      # OpenTofu: OCI cluster, networking, Flux operator bootstrap
flux/                    # Flux CD core (flux-system/flux-system/ namespace via flux-operator)
flux-modules/            # GitOps modules:
  - cilium/                  # CNI + Gateway API (kube-proxy-less)
  - monitoring/              # kube-prometheus-stack, Grafana Alloy, Loki
  - kube-system/             # cert-manager, external-dns, VPA, storage-class
  - flux-system-extra/       # Flux notifications, GitHub commit status
  - extras/                  # Optional: wordpress, paperless, mariadb, mealie, wireguard
```

## Critical Constraints

- **Only 1 OCI Network Load Balancer (NLB) available for free** - all services must use `ClusterIP` + `HTTPRoute` (Gateway API) via `cilium-gw`. Never create additional `LoadBalancer` services.
- **Local storage only** - data volumes (50GB) are per-node, not shared. No distributed storage.
- **2 nodes max** (free tier limit).

## Secrets Workflow

Files ending in `.tpl.enc` are templates. For each one:
```sh
cp file.yaml.tpl.enc file.yaml          # copy
# edit file.yaml and base64-encode secrets: echo "VALUE" | base64 -w 0
sops -i -e file.yaml                     # encrypt in-place
git add file.yaml
```

## Linting / Formatting

```sh
pre-commit run --all-files              # runs yamlfmt (max line length 150) + checks
```

Formatting config: `.yamlfmt` (excludes `flux/flux-system/` and `**/*dashboard*.yaml`).

## Deploy Order

```sh
# 1. Infrastructure
cd tf && tofu init && tofu apply -var git_token="$GH_TOKEN"

# 2. Bootstrap Flux operator first (only after infra is ready)
tofu apply -target null_resource.flux_operator_bootstrap -var git_token="$GH_TOKEN"

# 3. Full apply (Flux takes over from here)
tofu apply -var git_token="$GH_TOKEN"

# 4. Push to GitHub so Flux can manage the cluster
git add . && git commit -am "bootstrap" && git push

# 5. Verify Flux status
kubectl get gitrepository -A && kubectl get kustomization -A
```

## Public Services via Gateway API

All public HTTP services use `HTTPRoute` resources referencing the `cilium-gw` gateway. cert-manager automatically issues Let's Encrypt certificates via Gateway API integration. DNS records via `external-dns` (optional, needs Cloudflare API token).

## Optional Extras

Enable by editing `flux-modules/extras/<app>/kustomization.yaml` or related pre-deploy kustomizations: `mariadb`, `paperless`, `wordpress`, `mealie`, `wireguard`.