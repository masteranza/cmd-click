#!/usr/bin/env swift
import AppKit

// Native vector artwork, rendered at every required size. Run from the repo root.
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let cursor: [(CGFloat, CGFloat)] = [(443, 279), (443, 705), (549, 600), (634, 784), (719, 744), (632, 566), (781, 566)]
let command = CGMutablePath()
command.move(to: CGPoint(x: 290, y: 320))
command.addLine(to: CGPoint(x: 390, y: 320))
command.addCurve(to: CGPoint(x: 422, y: 288), control1: CGPoint(x: 408, y: 320), control2: CGPoint(x: 422, y: 306))
command.addCurve(to: CGPoint(x: 390, y: 256), control1: CGPoint(x: 422, y: 270), control2: CGPoint(x: 408, y: 256))
command.addCurve(to: CGPoint(x: 358, y: 288), control1: CGPoint(x: 372, y: 256), control2: CGPoint(x: 358, y: 270))
command.addLine(to: CGPoint(x: 358, y: 420))
command.addCurve(to: CGPoint(x: 390, y: 452), control1: CGPoint(x: 358, y: 438), control2: CGPoint(x: 372, y: 452))
command.addCurve(to: CGPoint(x: 422, y: 420), control1: CGPoint(x: 408, y: 452), control2: CGPoint(x: 422, y: 438))
command.addCurve(to: CGPoint(x: 390, y: 388), control1: CGPoint(x: 422, y: 402), control2: CGPoint(x: 408, y: 388))
command.addLine(to: CGPoint(x: 258, y: 388))
command.addCurve(to: CGPoint(x: 226, y: 420), control1: CGPoint(x: 240, y: 388), control2: CGPoint(x: 226, y: 402))
command.addCurve(to: CGPoint(x: 258, y: 452), control1: CGPoint(x: 226, y: 438), control2: CGPoint(x: 240, y: 452))
command.addCurve(to: CGPoint(x: 290, y: 420), control1: CGPoint(x: 276, y: 452), control2: CGPoint(x: 290, y: 438))
command.addLine(to: CGPoint(x: 290, y: 288))
command.addCurve(to: CGPoint(x: 258, y: 256), control1: CGPoint(x: 290, y: 270), control2: CGPoint(x: 276, y: 256))
command.addCurve(to: CGPoint(x: 226, y: 288), control1: CGPoint(x: 240, y: 256), control2: CGPoint(x: 226, y: 270))
command.addCurve(to: CGPoint(x: 258, y: 320), control1: CGPoint(x: 226, y: 306), control2: CGPoint(x: 240, y: 320))
command.closeSubpath()

func render(size: Int, to path: String) throws {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let graphics = NSGraphicsContext(bitmapImageRep: bitmap)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphics
    let context = graphics.cgContext
    context.scaleBy(x: CGFloat(size) / 1024, y: CGFloat(size) / 1024)
    context.translateBy(x: 0, y: 1024)
    context.scaleBy(x: 1, y: -1)
    let tile = CGPath(roundedRect: CGRect(x: 80, y: 80, width: 864, height: 864), cornerWidth: 194, cornerHeight: 194, transform: nil)
    context.saveGState()
    context.addPath(tile); context.clip()
    let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [
        CGColor(red: 0.20, green: 0.56, blue: 1, alpha: 1),
        CGColor(red: 0.10, green: 0.27, blue: 0.83, alpha: 1)
    ] as CFArray, locations: [0, 1])!
    context.drawLinearGradient(gradient, start: CGPoint(x: 200, y: 80), end: CGPoint(x: 830, y: 944), options: [])
    context.restoreGState()
    context.addPath(tile)
    context.setStrokeColor(CGColor(gray: 1, alpha: 0.18)); context.setLineWidth(4); context.strokePath()
    // A continuous Command-key mark.
    context.setStrokeColor(CGColor(gray: 1, alpha: 0.85)); context.setLineWidth(18)
    context.addPath(command); context.strokePath()
    let pointer = CGMutablePath()
    pointer.move(to: CGPoint(x: cursor[0].0, y: cursor[0].1))
    for p in cursor.dropFirst() { pointer.addLine(to: CGPoint(x: p.0, y: p.1)) }
    pointer.closeSubpath()
    context.setShadow(offset: CGSize(width: 0, height: 10), blur: 22, color: CGColor(red: 0.01, green: 0.07, blue: 0.3, alpha: 0.3))
    context.addPath(pointer); context.setFillColor(CGColor(gray: 1, alpha: 1))
    context.setStrokeColor(CGColor(red: 0.05, green: 0.17, blue: 0.43, alpha: 1))
    context.setLineWidth(22); context.setLineJoin(.round); context.drawPath(using: .fillStroke)
    NSGraphicsContext.restoreGraphicsState()
    let destination = root.appendingPathComponent(path)
    try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
    try bitmap.representation(using: .png, properties: [:])!.write(to: destination)
}

let catalog = "macOS/Command Click Rescue/Command Click Rescue/Assets.xcassets/AppIcon.appiconset"
let data = try Data(contentsOf: root.appendingPathComponent("\(catalog)/Contents.json"))
let contents = try JSONSerialization.jsonObject(with: data) as! [String: Any]
for item in contents["images"] as! [[String: String]] {
    let points = Int(item["size"]!.split(separator: "x")[0])!
    let scale = Int(item["scale"]!.dropLast())!
    try render(size: points * scale, to: "\(catalog)/\(item["filename"]!)")
}
for size in [48, 64, 96, 128, 256, 512] { try render(size: size, to: "extension/icons/icon-\(size).png") }
try render(size: 256, to: "macOS/Command Click Rescue/Command Click Rescue/Resources/Icon.png")
try render(size: 1024, to: "app-store/icon-1024.png")
try render(size: 512, to: "docs/icon.png")
let commandSVG = "M290 320 H390 C408 320 422 306 422 288 C422 270 408 256 390 256 C372 256 358 270 358 288 V420 C358 438 372 452 390 452 C408 452 422 438 422 420 C422 402 408 388 390 388 H258 C240 388 226 402 226 420 C226 438 240 452 258 452 C276 452 290 438 290 420 V288 C290 270 276 256 258 256 C240 256 226 270 226 288 C226 306 240 320 258 320 Z"
let points = cursor.map { "\(Int($0.0)),\(Int($0.1))" }.joined(separator: " ")
let svg = """
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <defs><linearGradient id="blue" x1="0" y1="0" x2="1" y2="1"><stop stop-color="#338fff"/><stop offset="1" stop-color="#1945d4"/></linearGradient></defs>
  <rect x="80" y="80" width="864" height="864" rx="194" fill="url(#blue)" stroke="#ffffff" stroke-opacity=".18" stroke-width="4"/>
  <g fill="none" stroke="#ffffff" stroke-opacity=".85" stroke-width="18"><path d="\(commandSVG)"/></g>
  <polygon points="\(points)" fill="white" stroke="#0d2b6e" stroke-width="22" stroke-linejoin="round"/>
</svg>
"""
try svg.write(to: root.appendingPathComponent("extension/icon.svg"), atomically: true, encoding: .utf8)
print("Generated cursor icons for macOS, Safari, GitHub Pages, and App Store artwork.")
