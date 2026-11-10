# shellcheck shell=bash
set -euo pipefail

NEW_VERSION="${1:?Usage: bash scripts/version-bump.sh <new-version>}"

echo "Bumping lefthook to v${NEW_VERSION}..."

if ! grep -q '^  version = ".*";$' nix/outputs.nix; then
  echo "version-bump: no version line in nix/outputs.nix" >&2
  exit 1
fi
sed "s/^  version = \".*\";/  version = \"${NEW_VERSION}\";/" nix/outputs.nix >nix/outputs.nix.tmp && mv nix/outputs.nix.tmp nix/outputs.nix
echo "Updated version to ${NEW_VERSION} in nix/outputs.nix"

echo "Fetching source hash for v${NEW_VERSION}..."
RAW_HASH=$(nix-prefetch-url --unpack --type sha256 \
  "https://github.com/evilmartians/lefthook/archive/v${NEW_VERSION}.tar.gz" 2>/dev/null)
SRC_HASH=$(nix hash convert --to sri "sha256:${RAW_HASH}")
sed "s|hash = \"sha256-.*\";|hash = \"${SRC_HASH}\";|" nix/lefthook-for.nix >nix/lefthook-for.nix.tmp && mv nix/lefthook-for.nix.tmp nix/lefthook-for.nix
echo "Updated hash to ${SRC_HASH} in nix/lefthook-for.nix"

echo "Computing vendorHash (this may take a moment)..."
PLACEHOLDER="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
sed "s|vendorHash = \"sha256-.*\";|vendorHash = \"${PLACEHOLDER}\";|" nix/lefthook-for.nix >nix/lefthook-for.nix.tmp && mv nix/lefthook-for.nix.tmp nix/lefthook-for.nix
BUILD_OUTPUT=$(nix build 2>&1 || true)
VENDOR_HASH=$(echo "${BUILD_OUTPUT}" | grep 'got:' | head -1 | sed 's/.*got:[[:space:]]*//' | tr -d ' ')
sed "s|vendorHash = \"${PLACEHOLDER}\";|vendorHash = \"${VENDOR_HASH}\";|" nix/lefthook-for.nix >nix/lefthook-for.nix.tmp && mv nix/lefthook-for.nix.tmp nix/lefthook-for.nix
echo "Updated vendorHash to ${VENDOR_HASH} in nix/lefthook-for.nix"

echo "Version bump to v${NEW_VERSION} complete!"
