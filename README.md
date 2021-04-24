# Kubernetes Create React App Example

[![Build and Release](https://github.com/terotuomala/k8s-create-react-app-example/workflows/build-and-release/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Vulnerability Scan](https://github.com/terotuomala/k8s-create-react-app-example/workflows/vulnerability-scan/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Lint](https://github.com/terotuomala/k8s-create-react-app-example/workflows/lint/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)

> :information_source: This project is a part of [GitOps workflow example using Flux2](https://github.com/terotuomala/gitops-flux2-example) which includes Kubernetes manifests for NGINX Ingress Controller as well as handles Continuous Delivery.

A simple example Single-page Application using Create React App running in Kubernetes.

<!-- TABLE OF CONTENTS -->
## Table of Contents
* [Features](#rocket-features)
* [Overview](#overview)
* [Kustomize configuration](#pencil-kustomize-configuration)
* [Usage](#joystick-usage)

<!-- FEATURES -->
## :rocket: Features
- Optimized Dockerfile using multi-stage builds
- SHA pinned Docker image tags with automated update using [Renovate](https://docs.renovatebot.com)
- Automated vulnerability scan of the Docker image and npm dependencies using [Trivy](https://github.com/aquasecurity/trivy)
- YAML validation using [yamllint](https://github.com/adrienverge/yamllint)
- Static file Caching utilizing [long term caching techniques](https://create-react-app.dev/docs/production-build/#static-file-caching) using [serve](https://github.com/vercel/serve)
- Kubernetes configuration customization using [Kustomize](https://github.com/kubernetes-sigs/kustomize)
- Network traffic flow control using [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

<!-- OVERVIEW -->
## :mag: Overview
In a nutshell the application provides a user interface for displaying most popular GitHub repositories which the [REST API](https://github.com/terotuomala/k8s-express-api-example) offers.

## :pencil: Kustomize configuration
Kustomize configuration is based on [Directory Structure Based Layout](https://kubectl.docs.kubernetes.io/pages/app_composition_and_deployment/structure_directories.html) in order to use staging and production environments with different configuration.

```sh
├── base
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── kustomization.yaml
│   ├── netpol-egress.yaml
│   ├── netpol-ingress.yaml
│   ├── pdb.yaml
│   └── service.yaml
├── production
│   ├── kustomization.yaml
│   └── namespace.yaml
└── staging
    ├── hpa-patch.yaml
    ├── kustomization.yaml
    ├── namespace.yaml
    └── pdb-patch.yaml
```

## :joystick: Usage
