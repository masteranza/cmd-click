#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
export DEVELOPER_DIR=${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}
archive_path=${ARCHIVE_PATH:-"$repo_dir/build/Command Click Rescue.xcarchive"}
case "${1:-}" in
  "")
    xcodebuild -quiet -project "$repo_dir/macOS/Command Click Rescue/Command Click Rescue.xcodeproj" \
      -scheme 'Command Click Rescue' -configuration Release -destination 'generic/platform=macOS' \
      -derivedDataPath "$repo_dir/build/ReleaseDerivedData" -archivePath "$archive_path" \
      -allowProvisioningUpdates DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM:-AG5A94227H}" \
      'ARCHS=arm64 x86_64' ONLY_ACTIVE_ARCH=NO archive
    ;;
  --unsigned)
    xcodebuild -quiet -project "$repo_dir/macOS/Command Click Rescue/Command Click Rescue.xcodeproj" \
      -scheme 'Command Click Rescue' -configuration Release -destination 'generic/platform=macOS' \
      -derivedDataPath "$repo_dir/build/ReleaseDerivedData" -archivePath "$archive_path" \
      'ARCHS=arm64 x86_64' ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO archive
    printf '%s\n' 'Unsigned verification archive only; use a signed archive for App Store distribution.' >&2
    ;;
  *) printf '%s\n' 'Usage: scripts/archive-macos.sh [--unsigned]' >&2; exit 2 ;;
esac
printf '%s\n' "$archive_path"
