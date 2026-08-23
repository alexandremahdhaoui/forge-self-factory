# FOLLOWUP — forge-self workspace

## Open

- External dependencies still resolve from committed go.mod files. Move
  them to register entries once forge-self-register carries go tracks.
- The pipeline gate is the unit stages of forge-factory and forge-register.
  Widen to full test-alls where minutes are cheap.

## Decided

- 2026-08-23: the toolchain lives under its own factory. Every forge and
  forge-* runnable declares forge-self-factory. No exceptions to the model.
- 2026-08-23: members keep committed go.mod and go.sum. That breaks the
  bootstrap cycle: go run works before any factory or cache exists. No
  member declares a language, so sync never rewrites them.
- 2026-08-23: publish is the only door into the internal track. The
  pipeline publishes each member with the minted revision as provenance.
