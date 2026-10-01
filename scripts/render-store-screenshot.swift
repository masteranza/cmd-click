#!/usr/bin/env swift
import AppKit

// Compose a real app capture into Apple's 2880 × 1800 Mac screenshot format.
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let source = NSImage(contentsOf: root.appendingPathComponent("app-store/setup-window.png"))!
let cgSource = source.cgImage(forProposedRect: nil, context: nil, hints: nil)!
// Exclude macOS's window title and screen-sharing indicator, leaving the actual app content.
let cropped = cgSource.cropping(to: CGRect(x: 0, y: 64, width: cgSource.width, height: cgSource.height - 64))!
let setup = NSImage(cgImage: cropped, size: NSSize(width: cropped.width, height: cropped.height))
let width = 2880, height = 1800
let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
    bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
ctx.translateBy(x: 0, y: CGFloat(height)); ctx.scaleBy(x: 1, y: -1)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: true)
NSColor(calibratedRed: 0.94, green: 0.96, blue: 0.99, alpha: 1).setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: width, height: height)).fill()
func text(_ content: String, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor) {
    let paragraph = NSMutableParagraphStyle(); paragraph.lineSpacing = 12
    (content as NSString).draw(in: NSRect(x: x, y: y, width: w, height: h), withAttributes: [
        .font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color, .paragraphStyle: paragraph
    ])
}
let blue = NSColor(calibratedRed: 0.13, green: 0.39, blue: 0.86, alpha: 1)
let ink = NSColor(calibratedRed: 0.08, green: 0.16, blue: 0.28, alpha: 1)
let muted = NSColor(calibratedRed: 0.34, green: 0.41, blue: 0.5, alpha: 1)
text("COMMAND CLICK RESCUE", x: 150, y: 200, w: 1200, h: 100, size: 36, weight: .semibold, color: blue)
text("Your click.\nA new tab.\nYour place,\npreserved.", x: 145, y: 360, w: 1260, h: 750, size: 136, weight: .bold, color: ink)
text("Keep Safari’s native ⌘-click working\non real web links.", x: 150, y: 1170, w: 1180, h: 210, size: 46, color: muted)
text("FREE  ·  SAFARI FOR MAC  ·  NO TRACKING", x: 150, y: 1480, w: 1200, h: 100, size: 30, weight: .semibold, color: blue)
let panel = NSRect(x: 1530, y: 160, width: 1150, height: 1450)
ctx.saveGState()
ctx.setShadow(offset: CGSize(width: 0, height: 15), blur: 55, color: CGColor(gray: 0.1, alpha: 0.14))
NSColor.white.setFill(); NSBezierPath(roundedRect: panel, xRadius: 28, yRadius: 28).fill()
ctx.restoreGState()
NSBezierPath(roundedRect: panel, xRadius: 28, yRadius: 28).addClip()
setup.draw(in: panel, from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
NSGraphicsContext.restoreGraphicsState()
try NSBitmapImageRep(cgImage: ctx.makeImage()!).representation(using: .png, properties: [:])!.write(to: root.appendingPathComponent("app-store/screenshots/01-command-click-2880x1800.png"))
print("Rendered App Store screenshot from the captured setup app.")
