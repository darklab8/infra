# Description

Repositories for
- raising servers/cluster for pet projects
- For infra specific applications (monitoring stuff for example)
- and for reusable modules/infra templates for reusage in other repositories

# Infra

```mermaid
mindmap
  cluster((microk8s
  cluster))
    Node with Amd64
      avorion server
      desc(this node is for stuff hard to migrate to arm)
    Node with Arm64
      fl-darkbot
      minecraft server
      desc(this node is default for running stuff because arm is cheaper)
```

links to projects running here:
- [fl-darkbot](<https://github.com/darklab8/fl-darkbot>)
- [game-servers](<https://github.com/darklab8/infra-game-servers>)
