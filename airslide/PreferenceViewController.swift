//
//  ViewController.swift
//  airslide
//
//  Created by Lucas on 26/01/2023.
//

import Cocoa
import ServiceManagement
import LaunchAtLogin

let userDefaults = UserDefaults.standard


class PreferenceViewController: NSViewController {
    
    @IBOutlet weak var openatlogin: NSButton!
    @IBOutlet weak var hideicon: NSButton!
    @IBOutlet weak var soundlist: NSComboBoxCell!
    
    @IBAction func openatlogin(_ sender: Any) {
        
    // BROKEN
//        if openatlogin.state == .on {
//            UserDefaults.standard.set(true, forKey: "openatlogin")
//
//            LaunchAtLogin.isEnabled = true
//
//        }
//        else {
//            UserDefaults.standard.set(false, forKey: "openatlogin")
//
//            LaunchAtLogin.isEnabled = false
//
//        }
    }
    
    @IBAction func hideicon(_ sender: Any) {
        
        if hideicon.state == .on {
  
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.statusItem?.isVisible = false
            
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(UserDefaults.standard.bool(forKey: "hideicon"))
        
        
        let soundOptions = ["Basso", "Blow", "Bottle", "Frog", "Funk", "Glass", "Hero", "Morse", "Ping", "Pop", "Purr", "Sosumi", "Submarine", "Tink"]

        soundlist.addItems(withObjectValues: soundOptions)
        
        //set default sound to "Puur" cuz it's nice
        if UserDefaults.standard.string(forKey: "actualsound")! == "" {
            soundlist.title = "Purr"
        }
        else {
            soundlist.title = UserDefaults.standard.string(forKey: "actualsound")!
        }
        
        if (UserDefaults.standard.value(forKey: "openatlogin") != nil) == true{
            openatlogin.state = .on
        }
            else {
            openatlogin.state = .off
            }
        
        if UserDefaults.standard.value(forKey: "hideicon") as! Int == 1{
            hideicon.state = .on
        
        }
        else {
            hideicon.state = .off
            
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

