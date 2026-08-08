#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

shopt -s nullglob
PATCHES=( "${SCRIPT_DIR}"/*.patch )
shopt -u nullglob

if [ ${#PATCHES[@]} -eq 0 ]; then
    echo "[patch] No patch files found in ${SCRIPT_DIR}"
    exit 0
fi

if git am --ignore-space-change --ignore-whitespace "${PATCHES[@]}"; then
    echo "[patch] Applied ${#PATCHES[@]} patch(es) via git am (author metadata preserved)"
else
    echo "[patch] git am failed, falling back to git apply"
    git am --abort 2>/dev/null || true
    git apply "${PATCHES[@]}"
    echo "[patch] Applied ${#PATCHES[@]} patch(es) via git apply"
fi
