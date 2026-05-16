import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // iPhone 14 Pro 비율로 고정
    let width: CGFloat = 390
    let height: CGFloat = 844
    let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1200, height: 900)
    let x = screenFrame.midX - width / 2
    let y = screenFrame.midY - height / 2
    self.setFrame(NSRect(x: x, y: y, width: width, height: height), display: true)
    self.styleMask.remove(.resizable)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
