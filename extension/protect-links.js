(() => {
  "use strict";

  // Register at document_start, on the earliest point of the capture path.
  // Stopping propagation without preventDefault leaves Safari's own link
  // activation in charge of the new tab and its foreground/background choice.
  const eventTypes = ["pointerdown", "mousedown", "pointerup", "mouseup", "click", "auxclick"];

  function navigableLink(event) {
    const path = typeof event.composedPath === "function" ? event.composedPath() : [event.target];

    for (const node of path) {
      if (!node || node.nodeType !== 1) continue;
      const name = node.localName;
      if (name !== "a" && name !== "area") continue;
      if (node.hasAttribute("download")) return null;

      const rawHref = node.getAttribute("href");
      if (!rawHref) return null;

      try {
        const url = new URL(rawHref, node.baseURI);
        if (url.protocol === "http:" || url.protocol === "https:") return node;
      } catch {
        return null;
      }
      return null;
    }

    return null;
  }

  function protect(event) {
    if (!event.isTrusted || !event.metaKey || event.button !== 0) return;
    if (!navigableLink(event)) return;

    event.stopImmediatePropagation();
  }

  for (const type of eventTypes) {
    window.addEventListener(type, protect, { capture: true, passive: true });
  }
})();
