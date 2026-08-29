#!/bin/sh
set -eu

# Put the workspace files at the workspace root.
#
# The files are hand written inputs, not generated output. The root is not
# a git repo, so they live here and are copied up.
#
# A destination that already carries a different factory is someone else's
# workspace. Refuse it: this checkout may sit inside another workspace, and
# placing there would clobber it.

# Run from the factory checkout, never from the directory above it. Every
# source path below is relative to the current directory, so from one level up
# each one misses, the loop copies nothing, and the closing line still claims
# success. That silence hid a broken CI checkout for eight scheduled runs.
[ -f "workspace/forge-factory.yaml" ] || {
    echo "place: no workspace/forge-factory.yaml here." >&2
    echo "place: run me from inside the factory checkout." >&2
    exit 1
}

DEST="${1:-..}"

if [ -f "$DEST/forge-factory.yaml" ] \
    && ! grep -q '^name: forge-self$' "$DEST/forge-factory.yaml"; then
    echo "place: $DEST carries a different factory; refusing to overwrite it" >&2
    echo "place: pass an empty directory, or bootstrap with: forge clone" >&2
    exit 0
fi

for f in forge-factory.yaml forge-ci.yaml CLAUDE.md FOLLOWUP.md; do
    [ -f "workspace/$f" ] || continue

    if [ -f "$DEST/$f" ] && cmp -s "workspace/$f" "$DEST/$f"; then
        continue
    fi

    cp "workspace/$f" "$DEST/$f"
    echo "place: wrote $DEST/$f"
done

echo "place: the workspace files are in place. run forge-factory sync next."
