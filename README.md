# Command Click Rescue

A Safari web extension that protects native Command-click on real web links from JavaScript click handlers. It runs at document start in every web frame. On a Command-click over an HTTP(S) anchor or image-map area, it stops page event listeners while allowing Safari's normal link action to continue. Ordinary clicks are untouched.

## Test in Safari 27

1. Open **Safari → Settings → Advanced** and turn on **Show features for web developers**.
2. Open **Safari → Settings → Developer**, turn on **Allow unsigned extensions**, and click **Add Temporary Extension…**.
3. Select this repository's `extension` folder. In **Settings → Extensions**, enable **Command Click Rescue** and grant it access to websites (for the Ubiquiti test, `eu.store.ui.com` is sufficient).
4. Reload [the Ubiquiti product category](https://eu.store.ui.com/eu/en/category/integrations-power-tech). Command-click a product card. The original page should stay put and the product should open in a new tab.

Safari removes temporary extensions after 24 hours or when Safari quits. Reload it from the Extensions settings after editing these files.

## Build the macOS app

The `macOS` Xcode project packages the same files from `extension`. Run `./scripts/build-macos.sh` with Xcode 27 installed. The script prints the resulting `.app` path. Open that app once, then enable its extension in Safari Settings → Extensions. An ad hoc local build requires **Allow unsigned extensions** in Safari Settings → Developer each time Safari starts.

Run the behavior checks with `node --test tests/protect-links.test.js`.

## Scope

This protects genuine HTTP(S) links, including links inside shadow DOM and frames where Safari permits content scripts. A site can render a clickable element with no link URL in the DOM, or run code before an extension is injected. No web extension can infer an arbitrary destination or guarantee interception of every possible script-driven navigation. Report a failing page so its behavior can be examined and support expanded without guessing destinations.

## Mac App Store release

The extension is being prepared for a **free** Mac App Store release, with no subscriptions or in-app purchases. Public source: [masteranza/cmd-click](https://github.com/masteranza/cmd-click).

[Website](https://masteranza.github.io/cmd-click/) · [Support](https://masteranza.github.io/cmd-click/support.html) · [Privacy policy](https://masteranza.github.io/cmd-click/privacy.html) · [Command-click demo](https://masteranza.github.io/cmd-click/demo.html)

The [submission kit](app-store/README.md) includes listing copy, a cursor icon, a 2880 × 1800 App Store screenshot, and signed archive/export instructions. Run `./scripts/archive-macos.sh` to create the universal Release archive, or add `--unsigned` for local verification. The app and extension target macOS 12 or later; Safari 27 is currently tested, and earlier versions still need device testing before release.

## Icon assets

`extension/icon.svg` is the vector cursor-and-Command artwork. Run `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun swift scripts/generate-icons.swift` from the repository root to regenerate the macOS asset catalog, Safari PNG icons, companion-app icon, and website icon.

## GitHub Pages

The static marketing, support, privacy, and review-demo pages are in `docs/`. GitHub Pages serves `main` → `/docs`. They use no analytics, cookies, or third-party fonts.
