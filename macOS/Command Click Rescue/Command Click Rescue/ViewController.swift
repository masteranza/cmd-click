import Cocoa
import SafariServices
import WebKit

private final class WeakMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    init(_ delegate: WKScriptMessageHandler) { self.delegate = delegate }
    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(controller, didReceive: message)
    }
}

class ViewController: NSViewController, WKNavigationDelegate, WKScriptMessageHandler {
    @IBOutlet var webView: WKWebView!
    private var extensionBundleIdentifier: String { "\(Bundle.main.bundleIdentifier!).Extension" }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.configuration.userContentController.add(WeakMessageHandler(self), name: "controller")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshExtensionState),
            name: NSApplication.didBecomeActiveNotification, object: nil)
        guard let page = Bundle.main.url(forResource: "Main", withExtension: "html"),
              let resources = Bundle.main.resourceURL else { return }
        webView.loadFileURL(page, allowingReadAccessTo: resources)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { refreshExtensionState() }

    @objc private func refreshExtensionState() {
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { [weak self] state, error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let state, error == nil {
                    self.webView.evaluateJavaScript("show(\(state.isEnabled))")
                } else {
                    self.webView.evaluateJavaScript("show(null)")
                }
            }
        }
    }

    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.body as? String == "open-preferences" else { return }
        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { [weak self] error in
            DispatchQueue.main.async {
                if error != nil { self?.webView.evaluateJavaScript("showSettingsError()") }
            }
        }
    }
}
