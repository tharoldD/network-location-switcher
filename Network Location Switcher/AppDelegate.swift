//
//  AppDelegate.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 20/10/2017.
//  Copyright © 2017 Harold Turyasingura. All rights reserved.
//

import Cocoa
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let store = Store()
        let shell = Shell()
        store.emptyStore()
        store.storeLocations(locations: shell.getLocations())
        store.storeNetworks(networks: shell.getNetworks())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
