# Description

This repository is for:

- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# Prefered Container Scheduling engine

Docker with Swarm was chosen over Kubernetes for homelab because:
- Docker/Swarm is more lightweight. Microk8s that was tried for k8s, required 1.2gb RAM for hello world.
- Microk8s was freezing from time to time.
- K8s in self hosted way requires extra dependencies to run itself in multiple amount, with high decaying rate. Metallb, ingress nginx
- If we would have went for K8s, we would be needing to keep up with community supported helm charts for monitoring stuff at lest that bring even more infra code. Infra code is still a code, homelab done in a free time must be using our time very efficiently and justified.

In the long run, projects running with code from this repo are meant to be running for years with minimum effort in a stable way in a cheap way from Hetzner single server. The aim to have only minimal need for support that could be performed as rarely as once in a year or two. For this reason Docker Swarm is prefered default. Kubernetes way will remain as experimental extra way to run things. Projects could be having optional switch for their running in Kubernetes for the same experimental purposes from time to time may be, but they will be always having Docker/Swarm running way being available first. If some day Kubernetes benefits will overweight Docker Swarm way to run, this may change.

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
