# forge-self-factory

The forge toolchain under its own factory. This repo owns the forge-self
workspace files under `workspace/`; everything a workspace needs is
generated from them.

Bootstrap from nothing:

```sh
forge clone git@github.com:alexandremahdhaoui/forge-self-factory.git
```

Members: forge, forge-ci, forge-factory, forge-register, the three spec
repos, forge-self-register and forge-self-state. Every member keeps its
go.mod and go.sum committed, so `go run <module>@<version>` works before
any factory or cache exists. No member declares a language, so sync
generates no manifest here and the committed files stand.

Versions come from forge-self-register's internal track, published by the
pipeline on green with the minted revision as provenance. That is what a
runnable's `factory:` pointing here buys: `forge run <module> <name>`
resolves with no version typed.
