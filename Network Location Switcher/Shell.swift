//
//  Shell.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 22/07/2018.
//  Copyright © 2018 Harold Turyasingura. All rights reserved.
//

import Foundation

class Shell {
    
    // Get saved wifi names
    func getNetworks() -> [String] {
        var networks = [String]()
        let (output, terminationStatus) = runCommand(arguments: ["-c", "defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | grep SSIDString"])
        if (terminationStatus == 0) {
            let arrayOfWifi = output?.components(separatedBy: CharacterSet.newlines)
            
            for var wifi in arrayOfWifi! {
                wifi = cleanWifiNames(dirty: wifi)
                if( wifi != "" ) {
                    networks.append(wifi)
                }
                
            }
        }
        return networks
    }
    
    // Get saved Network Locations
    func getLocations() -> [String] {
        var locations = [String]()
        let (output2, terminationStatus2) = runCommand(arguments: ["-c","scselect | tail -n +2 | cut -d \"(\" -f 2 | cut -d \")\" -f 1"])
        if (terminationStatus2 == 0) {
            let arrayOfLocations = output2?.components(separatedBy: CharacterSet.newlines)
            
            for var location in arrayOfLocations! {
                location = location.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if( location != "" ) {
                    locations.append(location)
                }
            }
        }
        return locations
    }
    
    func setCurrentLocation(location: String) -> (String?, Int32) {
        return runCommand(arguments: ["-c","scselect \(location)"])
    }
    
    
    func runCommand(arguments: [String] = []) -> (String?, Int32) {
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
    
    func cleanWifiNames(dirty: String) -> String {
        var clean = dirty
        clean = clean.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (clean.hasPrefix("SSIDString = ")) {
            clean = clean.replaceFirstOccurence(target: "SSIDString = ", withString: "")
        }
        if (clean.hasPrefix("\"")) {
            clean = clean.replaceFirstOccurence(target: "\"", withString: "")
        }
        if (clean.hasSuffix("\";")) {
            clean = clean.replaceLastOccurrence(target: "\";", withString: "")
        }
        if (clean.hasSuffix(";")) {
            clean = clean.replaceLastOccurrence(target: ";", withString: "")
        }
        return clean.trimmingCharacters(in: CharacterSet.decomposables)
    }
    
    func getCurrentWifi() -> String {
        let (output, terminationStatus) =  runCommand(arguments: ["-c","/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I"])

        if (terminationStatus == 0) {
            if (output == "AirPort: Off\n") {
                return output!
            }
            let networkStatusArray = output?.components(separatedBy: CharacterSet.newlines)
            
            for var wifi in networkStatusArray! {
                wifi = wifi.trimmingCharacters(in: CharacterSet.whitespaces)
                if (wifi.contains("SSID") && wifi.hasPrefix("S")) {
                    return wifi.replaceFirstOccurence(target: "SSID: ", withString: "")
                }
            }
        }
        return ""
    }
}
