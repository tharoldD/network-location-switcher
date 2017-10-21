//
//  ViewController.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 20/10/2017.
//  Copyright © 2017 Harold Turyasingura. All rights reserved.
//
//  Borrowed ideas from...
//  https://stackoverflow.com/a/42403944
//  https://github.com/rimar/wifi-location-changer

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var networksPopUp: NSPopUpButton!
    @IBOutlet weak var locationsPopUp: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get saved location names
        let (output, terminationStatus) = shell(arguments: ["-c", "defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | grep SSIDString"])
        if (terminationStatus == 0) {
            let arrayOfWifi = output?.components(separatedBy: CharacterSet.newlines)
            
            for var aWifi in arrayOfWifi! {
                aWifi = aWifi.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if (aWifi.hasPrefix("SSIDString = ")) {
                    aWifi = aWifi.stringByReplacingFirstOccurrenceOfString(target: "SSIDString = ", withString: "")
                }
                if (aWifi.hasPrefix("\"")) {
                    aWifi = aWifi.stringByReplacingFirstOccurrenceOfString(target: "\"", withString: "")
                }
                if (aWifi.hasSuffix("\";")) {
                    aWifi = aWifi.stringByReplacingLastOccurrenceOfString(target: "\";", withString: "")
                }
                if (aWifi.hasSuffix(";")) {
                    aWifi = aWifi.stringByReplacingLastOccurrenceOfString(target: ";", withString: "")
                }
                aWifi = aWifi.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                networksPopUp.addItem(withTitle: aWifi)
            }
        }
        // Get saved Network Locations
        let (output2, terminationStatus2) = shell(arguments: ["-c","scselect | tail -n +2 | cut -d \"(\" -f 2 | cut -d \")\" -f 1"])
        if (terminationStatus2 == 0) {
            let arrayOfLocations = output2?.components(separatedBy: CharacterSet.newlines)
            
            for var aLocation in arrayOfLocations! {
                aLocation = aLocation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                aLocation = aLocation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                locationsPopUp.addItem(withTitle: aLocation)
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func shell(arguments: [String] = []) -> (String?, Int32) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        return (output, task.terminationStatus)
    }

}

