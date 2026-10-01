# Mac App Store submission kit

Command Click Rescue 1.0.0 (build 1) is prepared as a **free** macOS Safari extension, with no purchases or subscriptions. This directory contains the listing fields, 1024-pixel icon, and an actual app capture composed into a 2880 × 1800 screenshot. Free pricing is saved in App Store Connect for app **6818095124**, with availability in all 175 countries or regions on release.

## Product page

Copy the fields from [listing.json](listing.json). Set the primary category to Utilities and select **Free ($0.00)** under Pricing and Availability. Complete the current age-rating questionnaire based on the app's actual functionality; it has no accounts, advertising, user-generated content, or embedded general-purpose browser. Do not guess answers from the websites a user might visit in Safari. Add your App Review contact information in App Store Connect.

- Marketing URL: https://masteranza.github.io/cmd-click/
- Support URL: https://masteranza.github.io/cmd-click/support.html
- Required privacy policy URL: https://masteranza.github.io/cmd-click/privacy.html
- App Privacy answer: **No, we do not collect data from this app / Data Not Collected.** Website access is used only for processing the clicked link on-device.
- Screenshot: `screenshots/01-command-click-2880x1800.png` (RGB PNG, 16:10).
- Public reviewer test: https://masteranza.github.io/cmd-click/demo.html
- No login or purchase is required for review.

## Build and sign

Xcode 27 is installed on the preparation machine. The app and extension share version 1.0.0, build 1, and a macOS 12 deployment target. The existing developer certificate identifies Team AG5A94227H, which is configured in both targets. Override DEVELOPMENT_TEAM when archiving for a different team and update ExportOptions.plist to match.

```sh
./scripts/archive-macos.sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -exportArchive \
  -archivePath 'build/Command Click Rescue.xcarchive' \
  -exportPath build/AppStore \
  -exportOptionsPlist app-store/ExportOptions.plist \
  -allowProvisioningUpdates
```

ExportOptions uses `destination=export`: this creates a local distribution package without uploading it. Open the archive in Xcode Organizer and choose Distribute App → App Store Connect to validate and upload, or upload the exported `.pkg` with Transporter. Create the app record with bundle ID `dev.ranza.commandclickrescue`. The extension uses `dev.ranza.commandclickrescue.Extension`. Uploading and submitting for review are separate actions.

For unsigned build verification without an Xcode account:

```sh
ARCHIVE_PATH="$PWD/build/Unsigned.xcarchive" ./scripts/archive-macos.sh --unsigned
```

An unsigned archive cannot be submitted. Keep credentials, signing keys, profiles, and generated build output out of Git.

## Verification and remaining submission steps

Completed on October 1, 2026:

- All five `node --test tests/protect-links.test.js` checks pass.
- Local app builds; the real setup window, extension status, and layout were inspected.
- Signed universal Release archive builds for arm64 and x86_64.
- App Store distribution export and upload succeed; processed build 1.0.0 (1) is attached to the version.
- Product description, promotional text, keywords, URLs, copyright, screenshot, subtitle, and Utilities category are saved in App Store Connect.
- Age rating is 4+. Free pricing and worldwide availability are saved.
- Privacy policy URL and Data Not Collected responses are saved. Publishing the responses still requires confirming Apple's accuracy and update agreement.
- The host's network-client sandbox usage explanation is saved for App Review.
- Both bundles include the privacy manifest and matching version/build identifiers.
- Sandbox and hardened runtime are enabled. The host keeps the network-client entitlement for its WebKit view, but its CSP prohibits connections and all UI resources are bundled. The extension has only the sandbox entitlement.
- Template native-message logging and unused file-access entitlements are removed.

App Store Connect's Add for Review validation reports three remaining requirements: App Review contact name/email/phone, Content Rights Information, and publication of the prepared privacy responses. The app has not been submitted for review. The extension has been tested on Safari 27. Device testing on macOS 12 / earlier Safari versions and Intel hardware remains necessary if maintaining that minimum deployment target. Confirm extension activation and website permissions using the final App Store/TestFlight build.

## Artwork

The cursor and Command-key icon is native vector artwork. From the repository root:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun swift scripts/generate-icons.swift
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun swift scripts/render-store-screenshot.swift
```

The screenshot renderer uses the captured `setup-window.png`, crops macOS's title bar, and composes the actual app content; it does not synthesize app functionality.

## Apple references

- [Safari web extension distribution](https://developer.apple.com/documentation/safariservices/distributing-your-safari-web-extension)
- [Mac screenshot sizes](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- [App information and required privacy policy URL](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information)
- [App Sandbox](https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox)
