#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAR_PATH="${SCRIPT_DIR}/libs/Slimefun-Build-79809c0a.jar"
POM_PATH="${SCRIPT_DIR}/libs/Slimefun4-79809c0a.pom"

if [ ! -f "${JAR_PATH}" ]; then
    echo "File not found: ${JAR_PATH}"
    exit 1
fi

if [ ! -f "${POM_PATH}" ]; then
    echo "File not found: ${POM_PATH}"
    exit 1
fi

M2_REPO="${HOME}/.m2/repository"
DEST_DIR="${M2_REPO}/com/github/servernotdie/Slimefun4/79809c0a"

rm -rf "${DEST_DIR}"
mkdir -p "${DEST_DIR}"

cp "${JAR_PATH}" "${DEST_DIR}/Slimefun4-79809c0a.jar"
cp "${POM_PATH}" "${DEST_DIR}/Slimefun4-79809c0a.pom"

sha1sum "${DEST_DIR}/Slimefun4-79809c0a.jar" | awk '{print $1}' > "${DEST_DIR}/Slimefun4-79809c0a.jar.sha1"
sha1sum "${DEST_DIR}/Slimefun4-79809c0a.pom" | awk '{print $1}' > "${DEST_DIR}/Slimefun4-79809c0a.pom.sha1"

echo "Installed com.github.servernotdie:Slimefun4:79809c0a into the local Maven repository."
echo "You can now run: ./gradlew clean build"
