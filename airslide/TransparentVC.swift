import Cocoa

class TransparentVC: NSViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Set the frame for the view
    
        let screenRect = NSScreen.main?.frame
        let windowFrame = NSMakeRect(0, 0, screenRect!.width, screenRect!.height)
        let window = NSWindow(contentRect: windowFrame, styleMask: [.borderless], backing: .buffered, defer: false)

        
        
    }

  override func viewWillAppear() {
      
    super.viewWillAppear()

    self.view.window?.styleMask.remove(.titled)
    self.view.window?.styleMask.insert(.fullSizeContentView)
    self.view.window?.titlebarAppearsTransparent = true
    self.view.window?.titleVisibility = .hidden
    //self.view.window?.isMovable = false
    self.view.window?.showsResizeIndicator = false
    self.view.window?.isMovableByWindowBackground = true
      self.view.window?.isOpaque = false
      self.view.window?.backgroundColor = NSColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)

      
  }
}
