#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d .git/rebase-apply ]; then
    git am --abort
    echo "[revert] In-progress git am aborted, working tree restored"
    exit 0
fi

if [ "$(git log -1 --format=%an 2>/dev/null)" = "mytai20100" ]; then
    git reset --hard HEAD~1
    echo "[revert] Removed mytai20100's commit, source restored to pre-patch state"
else
    git apply -R "${SCRIPT_DIR}"/*.patch
    echo "[revert] Reverse-applied patches, source restored to pre-patch state"
fi
