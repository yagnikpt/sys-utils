#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <VERSION> [--test]"
  echo "Example: $0 v0.9.2 --test"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

VERSION="$1"
TEST_RUN=false
if [[ "${2:-}" == "--test" ]]; then
  TEST_RUN=true
fi

ARCHIVE="vicinae-linux-x86_64-${VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/vicinaehq/vicinae/releases/download/${VERSION}/${ARCHIVE}"
WORKDIR="$(mktemp -d)"
echo "Working in $WORKDIR"

cd "$WORKDIR"

echo "Downloading Vicinae ${VERSION}..."
if ! curl -fLO "${DOWNLOAD_URL}"; then
  echo "❌ Failed to download ${DOWNLOAD_URL}"
  exit 1
fi

echo "Extracting..."
tar xvf "${ARCHIVE}"

if $TEST_RUN; then
  echo "Running test..."
  ./bin/vicinae --help || true
fi

echo "Installing..."
sudo cp bin/* /usr/local/bin/
sudo cp -r share/* /usr/local/share/

echo "Cleaning up..."
rm -rf "$WORKDIR"

echo "✅ Done. Run 'vicinae server' to start the backend, or 'vicinae' for the launcher UI."

