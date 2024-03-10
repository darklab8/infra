# Description

This repository is for:
- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

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

links to projects running here:
- [fl-darkbot](<https://github.com/darklab8/fl-darkbot>)
- [game-servers](<https://github.com/darklab8/infra-game-servers>)
