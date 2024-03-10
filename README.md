# Description

This repository is for:
- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# links to projects running here:

| Link          | Logo |
| ------------- | ------------- |
| [microk8s](tf/modules/ansible_microk8s/)  | <img src="docs/assets/microk8s.png" style="width: 100px; height: 50px;"/>  |
| [fl-darkbot](<https://github.com/darklab8/fl-darkbot>)  |  <img src="docs/assets/darkbot.png" style="width: 50px; height: 50px;"/>  |
| [game-servers](<https://github.com/darklab8/infra-game-servers>)  | <img src="docs/assets/minecraft.png" style="width: 59px; height: 50px;"/> <img src="docs/assets/avorion_logo.png" style="width: 59px; height: 50px;"/>  |
| [argocd](tf/modules/kube_argo/)  |  <img src="docs/assets/argocd.png" style="width: 100px; height: 50px;"/>  |

# Infra

```mermaid
mindmap
  cluster((microk8s cluster))
    Node with Amd64
      desc(this node is for stuff hard to migrate to arm)
        avorion server
    Node with Arm64
      desc(this node is default for running stuff because arm is cheaper)
        fl-darkbot
        minecraft server
        argo cd
```
