# FOLLOWUP — forge-self workspace

## Open

- External dependencies still resolve from committed go.mod files. Move
  them to register entries once forge-self-register carries go tracks.
- forge's test stage runs every stage it declares except `integration`
  (a kind cluster) and `generated` (its regenerate builds container
  entries that want a daemon). A runner with docker would close both.
- mockery and golangci-lint are literal pins in `toolchain.binaries`;
  they become register tracks the day forge-self-register carries go
  tracks, which is the first open item.

## Decided

- 2026-08-23: the toolchain lives under its own factory. Every forge and
  forge-* runnable declares forge-self-factory. No exceptions to the model.
- 2026-08-23: members keep committed go.mod and go.sum. No member
  declares a language, so sync never rewrites them. Superseded in part on
  2026-09-04: the committed manifests no longer exist to let
  `go run <module>@<version>` seed CI - see below.
- 2026-09-04: the pipeline's jobs run in the published toolchain image,
  register-resolved from `internal:ghcr.io/alexandremahdhaoui/forge`,
  seeded at v0.45.62. `bootstrapCommand` is `forge clone`, the same line
  golden uses, and `toolchainScript` stays: the image supplies `forge`
  for the first clone only, and every real step runs the four binaries
  built from the checked-out members. Run 66 died on the proxy seed:
  `go run <module>@<version>` looks up `@latest` to report deprecation
  and found the tag `release-artifacts` had cut eleven seconds earlier,
  which sum.golang.org had not indexed. This reverses the earlier
  decision that forge-self must never run in its own image; the brick
  risk stands, and the recovery is a one-line pin edit in the register.
- 2026-09-04: substages carry `needs:`; the stage list is
  test -> build -> release, with the three publishes ordered inside the
  release stage. `jobs: stage`, so a run is five jobs. `publish-members`
  also publishes the image track, so the pin advances by proof rather
  than by hand.
- 2026-08-23: publish is the only door into the internal track. The
  pipeline publishes each member with the minted revision as provenance.
