function show(enabled) {
    const status = document.getElementById("status");
    status.dataset.state = enabled === true ? "on" : enabled === false ? "off" : "unknown";
    status.textContent = enabled === true
        ? "Extension enabled · Check your website access below"
        : enabled === false ? "Ready to enable in Safari"
        : "Enable the extension in Safari to get started";
}

function showSettingsError() { document.getElementById("settings-error").hidden = false; }

document.querySelector(".open-preferences").addEventListener("click", () => {
    document.getElementById("settings-error").hidden = true;
    window.webkit.messageHandlers.controller.postMessage("open-preferences");
});
