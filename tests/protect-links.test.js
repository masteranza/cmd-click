const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const test = require("node:test");
const vm = require("node:vm");

const source = fs.readFileSync(path.join(__dirname, "../extension/protect-links.js"), "utf8");

function install() {
  const listeners = new Map();
  const window = {
    addEventListener(type, handler, options) {
      listeners.set(type, { handler, options });
    },
  };
  vm.runInNewContext(source, { window, URL });
  return listeners;
}

function element(name, href, extra = {}) {
  return {
    nodeType: 1,
    localName: name,
    baseURI: "https://example.com/category",
    getAttribute(key) { return key === "href" ? href : null; },
    hasAttribute(key) { return key === "download" && Boolean(extra.download); },
  };
}

function dispatch(listeners, type, path, overrides = {}) {
  let stopped = false;
  let prevented = false;
  const event = {
    isTrusted: true,
    metaKey: true,
    button: 0,
    target: path[0],
    composedPath: () => path,
    stopImmediatePropagation() { stopped = true; },
    preventDefault() { prevented = true; },
    ...overrides,
  };
  listeners.get(type).handler(event);
  return { stopped, prevented };
}

test("registers early passive capture listeners for navigation-triggering mouse events", () => {
  const listeners = install();
  assert.deepEqual([...listeners.keys()], ["pointerdown", "mousedown", "pointerup", "mouseup", "click", "auxclick"]);
  for (const { options } of listeners.values()) {
    assert.equal(options.capture, true);
    assert.equal(options.passive, true);
  }
});

test("Command-click on a nested link blocks page handlers but leaves native navigation available", () => {
  const listeners = install();
  const link = element("a", "/product");
  const child = element("span", null);
  for (const type of listeners.keys()) {
    assert.deepEqual(dispatch(listeners, type, [child, link]), { stopped: true, prevented: false });
  }
});

test("ordinary and untrusted clicks are untouched", () => {
  const listeners = install();
  const link = element("a", "https://example.com/product");
  assert.equal(dispatch(listeners, "click", [link], { metaKey: false }).stopped, false);
  assert.equal(dispatch(listeners, "click", [link], { isTrusted: false }).stopped, false);
  assert.equal(dispatch(listeners, "click", [link], { button: 2 }).stopped, false);
});

test("non-links, downloads, and script URLs are untouched", () => {
  const listeners = install();
  for (const link of [element("div", null), element("a", "/file", { download: true }), element("a", "javascript:alert(1)")]) {
    assert.equal(dispatch(listeners, "click", [link]).stopped, false);
  }
});

test("a composed path finds links inside shadow DOM", () => {
  const listeners = install();
  const link = element("a", "https://example.com/product");
  const shadowChild = element("span", null);
  const host = element("custom-card", null);
  assert.equal(dispatch(listeners, "click", [shadowChild, link, host]).stopped, true);
});
