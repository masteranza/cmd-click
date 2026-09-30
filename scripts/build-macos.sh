#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
developer_dir=${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}

DEVELOPER_DIR="$developer_dir" xcodebuild \
  -quiet \
  -project "$repo_dir/macOS/Command Click Rescue/Command Click Rescue.xcodeproj" \
  -scheme 'Command Click Rescue' \
  -configuration Debug \
  -derivedDataPath "$repo_dir/build/DerivedData" \
  CODE_SIGN_IDENTITY=- \
  CODE_SIGNING_REQUIRED=NO \
  build

printf '%s\n' "$repo_dir/build/DerivedData/Build/Products/Debug/Command Click Rescue.app"
