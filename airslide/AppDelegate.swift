
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
        
        if UserDefaults.standard.bool(forKey: "openprefatlaunch") == true{
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let preferencesVC = storyboard.instantiateController(withIdentifier: "PreferencesViewController") as? NSViewController
            preferencesVC?.presentAsModalWindow(preferencesVC!)
        }
        
        //Setting status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "paperplane.fill", accessibilityDescription: nil)
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        
        //Defining each device screen size
        let MBP14 = (NSScreen.main?.frame.height)! == 982
        let MBP16 = (NSScreen.main?.frame.height)! > 1000 //to be sure
        let MBAM2 = (NSScreen.main?.frame.height)! < 980 //to be sure
        
        if MBP14{
            startMBP14()
        }
        if MBP16{
            startMBP16()
        }
        if MBAM2 {
            startMBAM2()
        }

        
        //First check for highlited files path
        AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            
            let frontmostApp = NSWorkspace.shared.frontmostApplication
            let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
            
            
            if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide"){
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
            
        }

        
        if MBP14{
            //Create notch view
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
            
            
            //Bring down view when mouse dragging enter top screen zone
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
                
                if !self.hasExecuted {
                    
                    let mousePoint = event.locationInWindow
                    let frontmostApp = NSWorkspace.shared.frontmostApplication
                    let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                    
                    if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") && mousePoint.y > 840 {
                        
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
            
            //Bring it back down if mouse drag quit top screen zone
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
               
                
                let mousePoint = event.locationInWindow
                
                if mousePoint.y < 840 {
                    if blueView.frame.midY == 111.5{
                        self.hasExecuted = false
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
            
            
            //Bring animation back up if mouse up
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted = false
                self.hasExecuted2 = false
                
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    
                    //hide only if in start position
                    if blueView.frame.midY == 117.5{
                        blueView.isHidden = true
                    }
                    
                    
                }
                
                
            }
            
        }
        
        //Same for 16"
        else if MBP16{
        
            let window = NSWindow(contentRect: NSMakeRect(725, 1001, 285.71, 113.74), styleMask: .borderless, backing: .buffered, defer: false) //THEORICAL VALUES
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
            
            //Show view when dragging mouse reach top of screen
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
                
                if !self.hasExecuted {
                    
                    let mousePoint = event.locationInWindow
                    let frontmostApp = NSWorkspace.shared.frontmostApplication
                    let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                    
                    
                    if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") && mousePoint.y > 950 {
                        
                        self.hasExecuted = true
                        
                        blueView.isHidden = false
                        
                        //down view animation
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= 6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
            
            //Bring it back down if mouse drag quit top screen zone
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
               
                
                let mousePoint = event.locationInWindow
                
                if mousePoint.y < 950 {
                    if blueView.frame.midY == 125.5{
                        self.hasExecuted = false
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
        
            //Hide view when mouse release
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted = false
                self.hasExecuted2 = false
                
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    //hide only if in start position
                    if blueView.frame.midY == 131.5{
                        blueView.isHidden = true
                    }
                    
                }
                
                
            }
        
        }
        
        //Same for MBAir
        else if MBAM2 {
        
            let window = NSWindow(contentRect: NSMakeRect(617.36, 856.70, 243.05, 97.35), styleMask: .borderless, backing: .buffered, defer: false) //THEORICAL VALUES
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
            
            //Show view when dragging mouse reach top of screen
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
                
                if !self.hasExecuted {
                    
                    let mousePoint = event.locationInWindow
                    let frontmostApp = NSWorkspace.shared.frontmostApplication
                    let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                    
                    
                    if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") && mousePoint.y > 827.87 {
                        
                        self.hasExecuted = true
                        
                        blueView.isHidden = false
                        
                        //down view animation
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= 6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
            
            //Bring it back down if mouse drag quit top screen zone
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
               
                //print(blueView.frame.midY)
                let mousePoint = event.locationInWindow
                
                if mousePoint.y < 827.87 {
                    if blueView.frame.midY == 109.5{
                        self.hasExecuted = false
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
            }
        
            //Hide view when mouse release
            AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { event in
                
                self.hasExecuted = false
                self.hasExecuted2 = false
                
                let frontmostApp = NSWorkspace.shared.frontmostApplication
                let frontmostAppBundleIdentifier = frontmostApp?.bundleIdentifier
                
                if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                    
                    //back up animation
                    if blueView.frame.midY == 109.5{
                        NSAnimationContext.runAnimationGroup({ (context) in
                            context.duration = 0.7
                            blueView.animator().frame.origin.y -= -6
                        }, completionHandler: {
                            blueView.frame.origin.y -= 0
                        })
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    //hide only if in start position
                    if blueView.frame.midY == 115.5{
                        blueView.isHidden = true
                    }
                    
                }
                
                
            }
        
        }
        
        
        
        
        
        //Show pref pane when clicking notch
        AppKit.NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            
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
                        
                        if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {
                            
                            let storyboard = NSStoryboard(name: "Main", bundle: nil)
                            let preferencesVC = storyboard.instantiateController(withIdentifier: "PreferencesViewController") as? NSViewController
                            preferencesVC?.presentAsModalWindow(preferencesVC!)


                            
                        }
                    }
                }
                else if MBP16 {
                    
                    if mouseY >= (screenHeight! - statusBarHeight) - 12 && mouseX > 756.42 && mouseX < 941.42 {

                        if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {

                            let storyboard = NSStoryboard(name: "Main", bundle: nil)
                            let preferencesVC = storyboard.instantiateController(withIdentifier: "PreferencesViewController") as? NSViewController
                            preferencesVC?.presentAsModalWindow(preferencesVC!)

                        }

                    }

                }
                else if MBAM2 {

                    if mouseY >= (screenHeight! - statusBarHeight) - 12 && mouseX > 646.52 && mouseX < 827.49 {

                        if (frontmostAppBundleIdentifier! == "com.apple.finder" || frontmostAppBundleIdentifier! == "mago.airslide") {

                            let storyboard = NSStoryboard(name: "Main", bundle: nil)
                            let preferencesVC = storyboard.instantiateController(withIdentifier: "PreferencesViewController") as? NSViewController
                            preferencesVC?.presentAsModalWindow(preferencesVC!)

                        }

                    }

                }
            }
        
        }
            
        
        
        //Drag on notch event
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
                else if MBAM2 {

                    if mouseY >= (screenHeight! - statusBarHeight) - 12 && mouseX > 646.52 && mouseX < 827.49 {

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
            
            //press "esc"
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
    
    //vvv ONLY FOR APP START INDICATOR PURPOSE vvv
    
    func startMBP14(){
        let window = NSWindow(contentRect: NSMakeRect(635, 880, 250, 100), styleMask: .borderless, backing: .buffered, defer: false)
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let blueView = NSView(frame: CGRect(x: 29, y: window.contentView!.frame.midY + 20 , width: window.contentView!.frame.width - 66, height: window.contentView!.frame.height - 5))
        blueView.wantsLayer = true
        blueView.layer?.backgroundColor = NSColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
        blueView.layer?.cornerRadius = 10
        blueView.isHidden = false
        
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
        
        
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= 6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= -6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                blueView.isHidden = true
            }
        }
}
    
    func startMBP16(){
        let window = NSWindow(contentRect: NSMakeRect(725, 1001, 285.71, 113.74), styleMask: .borderless, backing: .buffered, defer: false)
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let blueView = NSView(frame: CGRect(x: 29, y: window.contentView!.frame.midY + 20 , width: window.contentView!.frame.width - 66, height: window.contentView!.frame.height - 5))
        blueView.wantsLayer = true
        blueView.layer?.backgroundColor = NSColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
        blueView.layer?.cornerRadius = 10
        blueView.isHidden = false
        
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
        
        
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= 6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= -6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                blueView.isHidden = true
            }
        }
}
    
    func startMBAM2(){
        let window = NSWindow(contentRect: NSMakeRect(617.36, 856.70, 243.05, 97.35), styleMask: .borderless, backing: .buffered, defer: false)
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        
        let blueView = NSView(frame: CGRect(x: 29, y: window.contentView!.frame.midY + 20 , width: window.contentView!.frame.width - 66, height: window.contentView!.frame.height - 5))
        blueView.wantsLayer = true
        blueView.layer?.backgroundColor = NSColor(red: 0, green: 123/255, blue: 254/255, alpha: 1).cgColor
        blueView.layer?.cornerRadius = 10
        blueView.isHidden = false
        
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
        
        
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= 6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1
                blueView.animator().frame.origin.y -= -6
            }, completionHandler: {
                blueView.frame.origin.y -= 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                blueView.isHidden = true
            }
        }
}
    
}

