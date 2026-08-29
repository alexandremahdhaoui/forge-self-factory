#!/bin/sh
set -eu

ROOT="${1:-..}"

# When this checkout sits inside another workspace, the root carries that
# workspace's factory and there is nothing here to check against.

if [ -f "$ROOT/forge-factory.yaml" ] \
    && ! grep -q '^name: forge-self$' "$ROOT/forge-factory.yaml"; then
    echo "the root carries a different factory; nothing here to check"
    exit 0
fi

for f in forge-factory.yaml forge-ci.yaml; do
    if [ ! -f "$ROOT/$f" ]; then
        echo "no $f at $ROOT." >&2
        echo "  from nothing:   forge clone <this factory's url> $ROOT" >&2
        echo "  after editing:  pass --config workspace/$f to forge-factory" >&2
        exit 1
    fi

    if ! cmp -s "workspace/$f" "$ROOT/$f"; then
        echo "$f here and the one in play disagree." >&2
        echo "  from nothing:   forge clone <this factory's url> $ROOT" >&2
        echo "  after editing:  pass --config workspace/$f to forge-factory" >&2
        diff -u "workspace/$f" "$ROOT/$f" >&2 || true
        exit 1
    fi
done

if ! command -v forge-factory >/dev/null 2>&1; then
    echo "the factory matches the one in play. forge-factory is not installed, so"
    echo "it was not validated."
    exit 0
fi

forge-factory validate --config "$ROOT/forge-factory.yaml" >/dev/null

echo "the factory matches the one in play and forge-factory reads it"
