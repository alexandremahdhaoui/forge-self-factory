# CLAUDE.md — forge-self workspace

The toolchain under its own factory. Same model as the playground, no
exceptions: forge-self-factory owns membership, forge-self-register owns
adoptable versions, forge-self-state holds the proof.

Bootstrap from nothing:

```sh
forge clone git@github.com:alexandremahdhaoui/forge-self-factory.git
```

Every member keeps go.mod and go.sum committed so `go run <module>@<ver>`
works before any cache exists. No member declares a language, so sync
generates no manifest here.

Build and test any member with forge only:

```sh
forge build
forge test-all
```

The pipeline, run from the workspace root:

```sh
forge-ci apply --config forge-self-register/forge-ci.yaml --root .
```

It gates on the toolchain's own test suites, mints a revision pinning every
member's sha, and publishes each member into forge-self-register's internal
track with that revision as provenance. That is what makes
`forge run github.com/alexandremahdhaoui/forge-ci forge-ci` resolve with no
version typed.
