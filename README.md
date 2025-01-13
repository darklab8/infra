# Description

This repository is for:

- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# Languages in use


| name                                                  | Logo                                                                           | purpose                                                                      |
| ------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| [Docker](https://www.docker.com/)                     | <img src="docs/assets/docker.png" style="width: 80px; height: 50px;"/>                                                                               | App as a code with reproducability of a saved image to which we can rollback |
| [Opentofu](https://opentofu.org/)                     | <img src="docs/assets/tofu.png" style="width: 50px; height: 50px;"/>           | to setup Hetzner, DNS at cloudflare and docker containers and services.      |
| [Github Actions](https://github.com/features/actions) | <img src="docs/assets/github_actions.png" style="width: 50px; height: 50px;"/> | for automated testing and deployments in a fully GitOps way                  |
| [KCL](https://www.kcl-lang.io/)                       | <img src="docs/assets/kcl-logo.png" style="width: 50px; height: 50px;"/>       | To setup yaml of Github Actions with static typing and code reusage          |

# Projects here of using this repo code and infra:


| Link                                                                     | Logo                                                                                                                                                   | Description                                          |
| -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------- |
| [docker swarm](https://docs.docker.com/engine/swarm/)                    | <img src="docs/assets/swarm.png" style="width: 50px; height: 50px;"/>                                                                                  | simple container scheduler controlled by terraform   |
| [caddy docker proxy](https://github.com/lucaslorentz/caddy-docker-proxy) | <img src="docs/assets/caddy.jpg" style="width: 50px; height: 50px;"/>                                                                                  | reverse proxy and tls by labels to docker containers |
| [fl-darkbot](https://github.com/darklab8/fl-darkbot)                     | <img src="docs/assets/darkbot.png" style="width: 50px; height: 50px;"/>                                                                                | discord bot for Discovery Freelancer community       |
| [fl-darkstat](https://github.com/darklab8/fl-darkstat)                   | <img src="docs/assets/darkstat.png" style="width: 50px; height: 50px;"/>                                                                               | game data navigational tool for Freelancer           |
| [microk8s](tf/modules/ansible_microk8s/)                                 | <img src="docs/assets/microk8s.png" style="width: 50px; height: 50px;"/>                                                                              | k8s cluster for experiments                          |
| [argo-cd](https://argoproj.github.io/cd/)                                | <img src="docs/assets/argocd.png" style="width: 100px; height: 50px;"/>                                                                                | for experimental deploys to k8s                      |
| [game-servers](https://github.com/darklab8/infra-game-servers)           | <img src="docs/assets/minecraft.png" style="width: 59px; height: 50px;"/> <img src="docs/assets/avorion_logo.png" style="width: 59px; height: 50px;"/> | personal game servers, minecraft and avorion         |

```mermaid
mindmap
    ((cluster docker swarm))
        darkbot
            staging
            production
        darkstat
            [staging: darkstat-staging.dd84ai.com]
            [production: darkstat.dd84ai.com]
        caddy docker proxy
            (brings reverse proxy and tls
            to services by docker labels)
```
