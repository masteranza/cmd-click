"use strict";
document.getElementById("test-link").addEventListener("click", (event) => {
    event.preventDefault();
    document.getElementById("result").textContent = "The page’s click handler ran and is navigating this tab.";
    window.location.assign("demo-destination.html?intercepted=1");
});
