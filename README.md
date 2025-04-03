# Description

This repository is for:

- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# Prefered Container Scheduling engine

In the long run, projects running with code from this repo are meant to be running for years with minimum effort in a stable way in a cheap way from Hetzner single server. For this reason Docker Swarm is prefered default, as it does not have an array of things needed to be installed and kept up to date for its functioning. Kubernetes usage will remain for experimental and learning purposes only. Projects could be having optional switch for their running in Kubernetes for the same experimental purposes, but they will be always having Docker/Swarm running way being available first. If some day Kubernetes benefits will overweight Docker Swarm way to run, this may change.

# Languages in use


| name                                                  | Logo                                                                           | purpose                                                                      |
| ------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| [Docker](https://www.docker.com/)                     | <img src="docs/assets/docker.png" style="width: 80px; height: 50px;"/>         | App as a code with reproducability of a saved image to which we can rollback |
| [Opentofu](https://opentofu.org/)                     | <img src="docs/assets/tofu.png" style="width: 50px; height: 50px;"/>           | to setup Hetzner, DNS at cloudflare and docker containers and services.      |
| [Github Actions](https://github.com/features/actions) | <img src="docs/assets/github_actions.png" style="width: 50px; height: 50px;"/> | for automated testing and deployments in a fully GitOps way                  |
| [KCL](https://www.kcl-lang.io/)                       | <img src="docs/assets/kcl-logo.png" style="width: 50px; height: 50px;"/>       | To setup yaml of Github Actions with static typing and code reusage          |

# Production infra:


| Link                                                                     | Logo                                                                                                                                                   | Description                                          |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------- |
| [docker swarm](https://docs.docker.com/engine/swarm/)                    | <img src="docs/assets/swarm.png" style="width: 50px; height: 50px;"/>                                                                                  | simple container scheduler controlled by terraform   |
| [caddy docker proxy](https://github.com/lucaslorentz/caddy-docker-proxy) | <img src="docs/assets/caddy.jpg" style="width: 50px; height: 50px;"/>                                                                                  | reverse proxy and tls by labels to docker containers |
| [grafana](https://github.com/grafana/grafana) | <img src="docs/assets/grafana.png" style="width: 50px; height: 50px;"/>                                                                                  | visualizer of monitoring systems |
| [loki](https://github.com/grafana/loki) | <img src="docs/assets/loki.jpg" style="width: 50px; height: 50px;"/>                                                                                  | logging system |
| [alloy](https://github.com/grafana/alloy) | <img src="docs/assets/alloy.png" style="width: 50px; height: 50px;"/>                                                                                  | collector of logs/metrics/traces/profiles |
| [fl-darkbot](https://github.com/darklab8/fl-darkbot)                     | <img src="docs/assets/darkbot.png" style="width: 50px; height: 50px;"/>                                                                                | discord bot for Discovery Freelancer community       |
| [fl-darkstat](https://github.com/darklab8/fl-darkstat)                   | <img src="docs/assets/darkstat.png" style="width: 50px; height: 50px;"/>                                                                               | game data navigational tool for Freelancer           |

# Inactive and experimental infra

| Link                                                                     | Logo                                                                                                                                                   | Description                                          |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------- |
| [game-servers](https://github.com/darklab8/infra-game-servers)           | <img src="docs/assets/minecraft.png" style="width: 59px; height: 50px;"/> <img src="docs/assets/avorion_logo.png" style="width: 59px; height: 50px;"/> | personal game servers, minecraft and avorion         |
| [microk8s](tf/modules/ansible_microk8s/)                                 | <img src="docs/assets/microk8s.png" style="width: 50px; height: 50px;"/>                                                                               | k8s cluster for experiments                          |
| [argo-cd](https://argoproj.github.io/cd/)                                | <img src="docs/assets/argocd.png" style="width: 50px; height: 50px;"/>                                                                                | for experimental deploys to k8s                      |
