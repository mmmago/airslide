
import Cocoa
import AppKit
import Foundation



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSharingServiceDelegate {
    
    var hasExecuted = false
    var hasExecuted2 = false
    
    var filepath = ""
    
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var firstMenuItem: NSMenuItem?
    
    var statusBar: NSStatusBar!
    var statusItem: NSStatusItem?
    
    let mainScreen = NSScreen.main!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        let MBP14 = (NSScreen.main?.frame.height)! < 1000
        let MBP16 = (NSScreen.main?.frame.height)! > 1000
    
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "paperplane.fill", accessibilityDescription: nil)
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        
        //First check for highlited files path
        AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            
            let script = """
                tell application "Finder"
                    set theSelection to selection as alias list
                    set thePaths to {}
                    repeat with anItem in theSelection
                        set end of thePaths to POSIX path of anItem
                    end repeat
                    return thePaths
                end tell
                """
            let appleScript = NSAppleScript(source: script)
                    var error: NSDictionary?
                    if let result = appleScript?.executeAndReturnError(&error) {
                        let count = result.numberOfItems
                         self.filepath = ""
                        if result.numberOfItems != 0{
                            for index in 1...count {
                                if index == 1 {
                                    self.filepath += (result.atIndex(index)?.stringValue)!
                                } else {
                                    self.filepath += ", " + (result.atIndex(index)?.stringValue)!
                                }
                            }
                        }
                    } else if (error != nil) {
                        print("error: \(error!)")
                    }
            
        }

        
        if MBP14{
            
            let window = NSWindow(contentRect: NSMakeRect(635, 880, 250, 100), styleMask: .borderless, backing: .buffered, defer: false)
            window.level = .screenSaver
            window.isOpaque = false
            window.backgroundColor = .clear
            
            let blueView = NSView(frame: CGRect(x: 29, y: window.contentView!.frame.midY + 20 , width: window.contentView!.frame.width - 66, height: window.contentView!.frame.height - 5))
            blueView.wantsLayer = true
            blueView.layer?.backgroundColor = NSColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
            blueView.layer?.cornerRadius = 10
            blueView.isHidden = true
            
            let borderLayer = CALayer()
            borderLayer.frame = blueView.bounds
            borderLayer.cornerRadius = blueView.layer!.cornerRadius
            borderLayer.borderColor = NSColor.white.cgColor
            borderLayer.borderWidth = 6.0
            blueView.layer?.addSublayer(borderLayer)
            
            let animation = CABasicAnimation(keyPath: "borderColor")
            animation.fromValue = NSColor.clear.cgColor
            animation.toValue = NSColor.white.cgColor
            animation.duration = 1.618
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            borderLayer.add(animation, forKey: "borderColor")
            
            window.contentView?.addSubview(blueView)
            window.makeKeyAndOrderFront(nil)
            
            
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
                
                if !self.hasExecuted {
                    
                    let frontmostApp = NSWorkspace.shared.frontmostApplication
                    let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                    
                    if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                        
                        self.hasExecuted = true
                        
                        blueView.isHidden = false
                        
                        //down view animation
                        //print(blueView.frame.midY)
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= 6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
            
            
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted = false
                
                let frontmostApp = NSWorkspace.shared.frontmostApplication
                let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                
                if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                    
                    //back up animation
                    if blueView.frame.midY == 111.5{
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
                
                
            }
            
            //Mouse button released
            NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted2 = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    
                    //hide only if in start position
                    if blueView.frame.midY == 117.5{
                        blueView.isHidden = true
                    }
                    
                }
               

            }
            
        }
        
        else if MBP16{
        
            let window = NSWindow(contentRect: NSMakeRect(725, 1001, 285.71, 113.74), styleMask: .borderless, backing: .buffered, defer: false)
            window.level = .screenSaver
            window.isOpaque = false
            window.backgroundColor = .clear
            
            let blueView = NSView(frame: CGRect(x: 29, y: window.contentView!.frame.midY + 20 , width: window.contentView!.frame.width - 66, height: window.contentView!.frame.height - 5))
            blueView.wantsLayer = true
            blueView.layer?.backgroundColor = NSColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
            blueView.layer?.cornerRadius = 10
            blueView.isHidden = true
            
            let borderLayer = CALayer()
            borderLayer.frame = blueView.bounds
            borderLayer.cornerRadius = blueView.layer!.cornerRadius
            borderLayer.borderColor = NSColor.white.cgColor
            borderLayer.borderWidth = 6.0
            blueView.layer?.addSublayer(borderLayer)
            
            let animation = CABasicAnimation(keyPath: "borderColor")
            animation.fromValue = NSColor.clear.cgColor
            animation.toValue = NSColor.white.cgColor
            animation.duration = 1.618
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            borderLayer.add(animation, forKey: "borderColor")
            
            window.contentView?.addSubview(blueView)
            window.makeKeyAndOrderFront(nil)
            
            
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
                
                if !self.hasExecuted {
                    
                    let frontmostApp = NSWorkspace.shared.frontmostApplication
                    let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                    
                    if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                        
                        self.hasExecuted = true
                        
                        blueView.isHidden = false
                        
                        //down view animation
                        print(blueView.frame.midY)
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= 6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
            
            
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted = false
                
                let frontmostApp = NSWorkspace.shared.frontmostApplication
                let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                
                if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                    
                    //back up animation
                    if blueView.frame.midY == 125.5{
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
                
                
            }
            
            //Mouse button released
            NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted2 = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    
                    //hide only if in start position
                    if blueView.frame.midY == 117.5{
                        blueView.isHidden = true
                    }
                    
                }
               

            }
        
        }
        
            
        AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in

            let mousePoint = event.locationInWindow

            //Focus app on main screen
            if self.mainScreen.frame.contains(mousePoint) == true  {

                let statusBarHeight = NSStatusBar.system.thickness
                let screenHeight = NSScreen.main?.frame.height
                let mouseY = event.locationInWindow.y
                let mouseX = event.locationInWindow.x
                let frontmostApp = NSWorkspace.shared.frontmostApplication
                let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier

                if MBP14 {

                    if mouseY >= (screenHeight! - statusBarHeight) - 12 && mouseX > 665 && mouseX < 850  {

                        if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") { //So app only works on finder
                            
                           
                            self.dotherightthing()
                        }
                    }

                }

                else if MBP16 {

                    if mouseY >= (screenHeight! - statusBarHeight) - 12 && mouseX > 756.42 && mouseX < 941.42 {

                        if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {

                            self.dotherightthing()

                        }

                    }

                }


            }

        }
        
        
    }
    
    
    func dotherightthing(){
                
        if !hasExecuted2 {
            
            
            hasExecuted2 = true
            
            
            let sound = NSSound(named: UserDefaults.standard.value(forKey: "actualsound") as! NSSound.Name)
            
            sound?.play()
            
            let source = CGEventSource(stateID: .combinedSessionState)
                let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 53, keyDown: true)
                keyDown?.post(tap: .cghidEventTap)
            
            FileManager.default.fileExists(atPath: filepath)
            
            let fileURL = URL(fileURLWithPath: filepath)
            
            //if multiple files
            if filepath.contains(","){
                
                let separatedElements = filepath.components(separatedBy: ",")
                let trimmedElements = separatedElements.map { $0.trimmingCharacters(in: .whitespaces) }
                var fileURLs = [URL]()
                for element in trimmedElements {
                    let fileURL = URL(fileURLWithPath: element)
                    fileURLs.append(fileURL)
                }
                let sharingService = NSSharingService(named: NSSharingService.Name.sendViaAirDrop)
                sharingService?.delegate = self
                sharingService?.perform(withItems: fileURLs)
            }
            
            //if only one file
            else{
                let sharingService = NSSharingService(named: NSSharingService.Name.sendViaAirDrop)
                sharingService?.delegate = self
                sharingService?.perform(withItems: [fileURL])
                
                
            }
            
        }
        
    }
    
}
