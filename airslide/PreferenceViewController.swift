//
//  ViewController.swift
//  airslide
//
//  Created by Lucas on 26/01/2023.
//

import Cocoa


let userDefaults = UserDefaults.standard


class PreferenceViewController: NSViewController {
    
    @IBOutlet weak var openatlogin: NSButton!
    @IBOutlet weak var hideicon: NSButton!
    @IBOutlet weak var soundlist: NSComboBoxCell!
    @IBOutlet weak var support: NSButton!
    @IBOutlet weak var quitapp: NSButton!
    
    @IBAction func openatlogin(_ sender: Any) {
        
        if openatlogin.state == .on {

            if Bundle.main.bundlePath == "/Applications/AirSlide.app"{
                UserDefaults.standard.set(true, forKey: "openatlogin")
                UserDefaults.standard.set(false, forKey: "openprefatlaunch")
                let task = Process()
                task.launchPath = "/bin/bash"
                task.arguments = ["-c", "sh \(Bundle.main.resourcePath!)/login.sh"]
                task.launch()
                task.waitUntilExit()
                
            }
            else {
                openatlogin.state = .off
                UserDefaults.standard.set(false, forKey: "openatlogin")
                UserDefaults.standard.set(true, forKey: "openprefatlaunch")
                let alert = NSAlert()
                    alert.messageText = "Warning"
                    alert.informativeText = "Please put app in your Applications folder first !"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
            }

        }
        else if openatlogin.state == .off{
            UserDefaults.standard.set(false, forKey: "openatlogin")
            UserDefaults.standard.set(true, forKey: "openprefatlaunch")
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", "sh \(Bundle.main.resourcePath!)/nologin.sh"]
            task.launch()
            task.waitUntilExit()

        }
    }
    
    @IBAction func hideicon(_ sender: Any) {
        
        if hideicon.state == .on {
  
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.statusItem?.isVisible = false
            }
            
            UserDefaults.standard.set(true, forKey: "hideicon")
            
            
            
            
            
            
        } else {
            
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.statusItem?.isVisible = true
            
            UserDefaults.standard.set(false, forKey: "hideicon")
            
            
            

            
        }
    }
    
    
    @IBAction func soundlist(_ sender: Any) {

        
        UserDefaults.standard.set(soundlist.title, forKey: "actualsound")
        
        //preview sound
        let sound = NSSound(named: UserDefaults.standard.value(forKey: "actualsound") as! NSSound.Name)
        sound?.play()

    }
    
    
    @IBAction func quitapp(_ sender: Any) {
        if let window = NSApplication.shared.keyWindow {

            window.close()

        }
    }
    
    @IBAction func support(_ sender: Any) {
        guard let url = URL(string: "https://www.paypal.com/donate/?hosted_button_id=TUH8ECY3KP4BW") else { return }
        NSWorkspace.shared.open(url)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.bool(forKey: "hideicon"))
        print(UserDefaults.standard.bool(forKey: "actualsound"))
        print(UserDefaults.standard.bool(forKey: "openatlogin"))
    
        let soundOptions = ["Basso", "Blow", "Bottle", "Frog", "Funk", "Glass", "Hero", "Morse", "Ping", "Pop", "Purr", "Sosumi", "Submarine", "Tink"]

        soundlist.addItems(withObjectValues: soundOptions)
        
        //set default sound to "Puur" cuz it's nice
        if UserDefaults.standard.string(forKey: "actualsound") == nil {
            soundlist.title = "Purr"
            UserDefaults.standard.set("Purr", forKey: "actualsound")
        }
        else {
            soundlist.title = UserDefaults.standard.string(forKey: "actualsound")!
        }
        
        
        if UserDefaults.standard.value(forKey: "openatlogin") == nil {
            openatlogin.state = .off
            UserDefaults.standard.set(false, forKey: "openatlogin")
        }
        else if UserDefaults.standard.value(forKey: "openatlogin") as! Int == 1{
            openatlogin.state = .on
        }
            else if UserDefaults.standard.value(forKey: "openatlogin") as! Int == 0{
            openatlogin.state = .off
            }
        
        
        
        if UserDefaults.standard.value(forKey: "hideicon") == nil{
            hideicon.state = .off
            UserDefaults.standard.set(false, forKey: "hideicon")
        }
        else if UserDefaults.standard.value(forKey: "hideicon") as! Int == 1{
            hideicon.state = .on
        
        }
        else if UserDefaults.standard.value(forKey: "hideicon") as! Int == 0{ 
            hideicon.state = .off
            
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

