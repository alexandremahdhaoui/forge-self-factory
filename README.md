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
go.mod and go.sum committed. No member declares a language, so sync
generates no manifest here and the committed files stand.

The pipeline's jobs run in the published toolchain image, resolved from
forge-self-register's `internal:ghcr.io/alexandremahdhaoui/forge` track
into the generated `.forge/toolchain-image`. The image supplies `forge`
for the first clone and nothing else the pipeline relies on: every real
step runs the four binaries built from the checked-out members, which is
the code under test. Nothing seeds from the Go module proxy - a
`go run <module>@<version>` there looked up `@latest` for deprecation and
found the tag this very run had just cut, which the sum database had not
indexed yet.

Versions come from forge-self-register's internal track, published by the
pipeline on green with the minted revision as provenance. That is what a
runnable's `factory:` pointing here buys: `forge run <module> <name>`
resolves with no version typed.
