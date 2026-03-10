#!/usr/bin/env bash
set -euo pipefail

APP_PATH="/Applications/QClaw.app"
ASAR_PATH="$APP_PATH/Contents/Resources/app.asar"
WORK_DIR="$(mktemp -d)"

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

echo "==> Extracting app.asar..."
npx --yes @electron/asar extract "$ASAR_PATH" "$WORK_DIR/app"

# Find Chat-*.js (filename contains hash, use glob)
CHAT_JS=$(find "$WORK_DIR/app/out/renderer/assets" -name 'Chat-*.js' ! -name '*.css' | head -1)
if [ -z "$CHAT_JS" ]; then
  echo "ERROR: Chat-*.js not found"
  exit 1
fi
echo "==> Found: $(basename "$CHAT_JS")"

# Patch: set inviteVerified default to true (ref(false) -> ref(true))
# Original: const i=Z(!1),o=async F=>{var z,W,ue;if(i.value){await F();return}
# Patched:  const i=Z(!0),o=async F=>{var z,W,ue;if(i.value){await F();return}
SEARCH='const i=Z(!1),o=async F=>{var z,W,ue;if(i.value){await F();return}'
REPLACE='const i=Z(!0),o=async F=>{var z,W,ue;if(i.value){await F();return}'

if grep -qF "$SEARCH" "$CHAT_JS"; then
  sed -i '' "s|$(printf '%s' "$SEARCH" | sed 's/[|\\&]/\\&/g; s/!/\\!/g')|$(printf '%s' "$REPLACE" | sed 's/[|\\&]/\\&/g; s/!/\\!/g')|g" "$CHAT_JS"
  echo "==> Patched: inviteVerified default set to true"
elif grep -qF "$REPLACE" "$CHAT_JS"; then
  echo "==> Already patched, skipping"
else
  echo "ERROR: Patch pattern not found in $(basename "$CHAT_JS")"
  echo "       The app version may have changed. Manual inspection needed."
  exit 1
fi

echo "==> Repacking app.asar..."
npx --yes @electron/asar pack "$WORK_DIR/app" "$WORK_DIR/app-patched.asar"

echo "==> Backing up original app.asar..."
cp "$ASAR_PATH" "$ASAR_PATH.bak"

echo "==> Replacing with patched app.asar..."
cp "$WORK_DIR/app-patched.asar" "$ASAR_PATH"

echo "==> Done! Restart QClaw to take effect."
echo "    Backup saved at: $ASAR_PATH.bak"
