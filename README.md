# Description

This repository is for:

- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# links to projects running here:


| Link                                                                                              | Logo                                                                                                                                                   | Description                                        |
| --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------- |
| [docker swarm](https://docs.docker.com/engine/swarm/)                                             | <img src="docs/assets/swarm.png" style="width: 50px; height: 50px;"/>                                                                                  | simple container scheduler controlled by terraform |
| [microk8s](tf/modules/ansible_microk8s/)                                                          | <img src="docs/assets/microk8s.png" style="width: 100px; height: 50px;"/>                                                                              | k8s cluster for projects                           |
| [fl-darkbot](https://github.com/darklab8/fl-darkbot)                                              | <img src="docs/assets/darkbot.png" style="width: 50px; height: 50px;"/>                                                                                | discord bot for Discovery Freelancer community     |
| [fl-darkstat]([https://github.com/darklab8/fl-darkstat](https://github.com/darklab8/fl-darkstat)) |  <img src="docs/assets/darkstat.png" style="width: 50px; height: 50px;"/>                                                                                                                                                      | game data navigational tool for Freelancer         |
| [game-servers](https://github.com/darklab8/infra-game-servers)                                    | <img src="docs/assets/minecraft.png" style="width: 59px; height: 50px;"/> <img src="docs/assets/avorion_logo.png" style="width: 59px; height: 50px;"/> | personal game servers, minecraft and avorion       |

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
