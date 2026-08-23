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
