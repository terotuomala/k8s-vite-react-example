# K8s Create React App Example

[![Build and Release](https://github.com/terotuomala/k8s-create-react-app-example/workflows/build-and-release/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Vulnerability Scan](https://github.com/terotuomala/k8s-create-react-app-example/workflows/vulnerability-scan/badge.svg)](https://github.com/terotuomala/k8s-create-react-app-example/actions)
[![Lint](https://github.com/terotuomala/k8s-create-react-app-example/workflows/lint/badge.svg)](https://github.com/terotuomala/k8s-express-api-example/actions)

A simple Single-page Application example using Create React App designed to be running in Kubernetes.

> **NB.** this project is a part of [GitOps workflow example using Flux2](https://github.com/terotuomala/gitops-flux2-example) which includes Kubernetes manifests for NGINX Ingress Controller as well as handles Continuous Delivery.

<!-- TABLE OF CONTENTS -->
## Table of Contents 
* [Features](#rocket-features)
* [Kubernetes Objects](#blue_book-kubernetes-objects)
* [Kustomize configuration](#kustomize-configuration)
* [Usage](#usage)

<!-- FEATURES -->
## :rocket: Features 
- Kubernetes configuration customization using [Kustomize](https://github.com/kubernetes-sigs/kustomize)
- Continuous Delivery with GitOps workflow using [Flux2](https://github.com/fluxcd/flux2)
- Progressive delivery with canary releases using [Flagger](https://github.com/weaveworks/flagger)
- Kubernetes configuration best practises using [Kyverno](https://github.com/kyverno/kyverno)
- Network traffic flow control using [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- Kubernetes Secrets using [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- Kubernetes manifest validation using [pre-commit](https://github.com/pre-commit/pre-commit)

<!-- KUBERNETES OBJECTS -->
## :blue_book: Kubernetes Objects
The following applications and xxx runs in Kubernetes Cluster:

| Type |   | Client   | REST API   | Cache |
|:----------|---|:--------:|:----------:|:-------:|
| Ingress | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/ing.svg" alt="Ingress" title="Ingress resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :x:  |
| Service | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/svc.svg" alt="Service" title="Service resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Deployment | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/deploy.svg" alt="Deployment" title="Deployment resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Config Map | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/cm.svg" alt="Config Map" title="Config Map resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Secret | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/secret.svg" alt="Secret" title="Secret resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Pod Disruption Budget | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/quota.svg" alt="Pod Disruption Budget" title="Pod Disruption Budget resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Cluster Policy | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/psp.svg" alt="Cluster Policy" title="Kyverno Cluster Policy resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Network Policy | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/netpol.svg" alt="Network Policy" title="Network Policy resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| Horizontal Pod Autoscaler | <img src="https://github.com/kubernetes/community/blob/master/icons/svg/resources/unlabeled/hpa.svg" alt="Horizontal Pod Autoscaler" title="Horizontal Pod Autoscaler resource" width="34,39" height="33" /> | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |

## Kustomize configuration
Kustomize configuration is based on [Directory Structure Based Layout](https://kubectl.docs.kubernetes.io/pages/app_composition_and_deployment/structure_directories.html) in order to use staging and production environments with different configuration.

```sh
├── base
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── kustomization.yaml
│   └── service.yaml
├── production
│   ├── kustomization.yaml
│   └── namespace.yaml
└── staging
    ├── kustomization.yaml
    └── namespace.yaml
```

## Usage