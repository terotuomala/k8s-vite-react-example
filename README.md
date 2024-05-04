# Kubernetes Vite + React Example App

[![Build and Release](https://github.com/terotuomala/k8s-create-react-app-example/workflows/build-and-release/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Vulnerability Scan](https://github.com/terotuomala/k8s-create-react-app-example/workflows/vulnerability-scan/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Lint](https://github.com/terotuomala/k8s-create-react-app-example/workflows/lint/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)

> :information_source: This project is a part of [GitOps workflow example using Flux2](https://github.com/terotuomala/gitops-flux2-example) which includes Kubernetes manifests for NGINX Ingress Controller as well as handles Continuous Delivery.

A simple example Single-page Application for Kubernetes using Vite + React.

<!-- TABLE OF CONTENTS -->
## Table of Contents
* [Overview](#mag-overview)
* [Features](#rocket-features)
  * [Dockerfile optimization](#dockerfile-optimization)
  * [SHA256 digest pinned Docker image tags](#sha256-digest-pinned-docker-images)
  * [Docker image and npm dependency updates](#docker-image-and-npm-dependency-updates)
  * [Vulnerability scanning](#vulnerability-scanning)
  * [Static file Caching](#static-file-caching)
* [Kustomize configuration](#pencil-kustomize-configuration)
* [Local development](#keyboard-local-development)

<!-- OVERVIEW -->
## :mag: Overview
In a nutshell the application provides a user interface for displaying most popular GitHub repositories which the [REST API](https://github.com/terotuomala/k8s-express-api-example) offers.

<!-- FEATURES -->
## :rocket: Features
- Optimized Dockerfile using multi-stage builds
- SHA pinned Docker image tags with automated update using [Renovate](https://docs.renovatebot.com)
- Automated vulnerability scan of the Docker image and npm dependencies using [Trivy](https://github.com/aquasecurity/trivy)
- YAML validation using [yamllint](https://github.com/adrienverge/yamllint)
- Static file Caching utilizing [long term caching techniques](https://create-react-app.dev/docs/production-build/#static-file-caching) using [serve](https://github.com/vercel/serve)
- Kubernetes configuration customization using [Kustomize](https://github.com/kubernetes-sigs/kustomize)
- Network traffic flow control using [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### Dockerfile optimization
- In order to keep the Docker image size optimal a multi-stage builds is used
- The application is bundled and build into production mode as well as `serve` is installed in the `base` stage. 
- Only the `dist` folder and `serve` related files are copied from the `base` state to `release` stage in order to have minimum sized layers
- Only the layers from the `release` stage are pushed when the Docker image is build

### SHA256 digest pinned Docker images
SHA256 digest pinning is used to achieve reliable and reproducable builds. Using digest as the image's primary identifier instead of using a tag makes sure that specific version of the image is used.

### Docker image and npm dependency updates
In order to receive Docker image and npm dependency updates [Renovate](https://docs.renovatebot.com) is used to create a pull request when: 

- Newer digest from [chainguard/node-lts](https://hub.docker.com/r/chainguard/node-lts/tags) is available on Docker Hub 
- `Minor` or `Patch` update of a npm dependency is available

### Vulnerability scanning
In order to regularly scan Docker image and npm dependencies for vulnerabilities a scheduled [job](https://github.com/terotuomala/k8s-express-api-example/blob/main/.github/workflows/vulnerability-scan.yml) is used to build the Docker image and scan it's content using [Trivy](https://github.com/aquasecurity/trivy).

### Static file Caching
When building Create React App it makes sure that JavaScript and CSS files inside `dist/assets` folder will have a unique hash appended to the filename which makes possible to use [long term caching techniques](https://create-react-app.dev/docs/production-build/#static-file-caching):

- `Cache-Control: max-age=31536000` for `dist/assets`
- `Cache-Control: no-cache` for `index.html` 

are used to avoid browser re-downloading the assets if the file contents haven't changed and to make sure that updated `index.html` is always used. The headers are defined in [serve.json](https://github.com/terotuomala/k8s-create-react-app-example/blob/main/serve.json). 

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
└── staging
    ├── hpa-patch.yaml
    ├── kustomization.yaml
    ├── namespace.yaml
    └── pdb-patch.yaml
```

<!-- LOCAL DEVELOPMENT -->
## :keyboard: Local development
Start the app in development mode which will automatically reload if you make changes to the code:
```sh
$ pnpm run dev
```
