//
//  Store.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 22/07/2018.
//  Copyright © 2018 Harold Turyasingura. All rights reserved.
//

import Foundation
import RealmSwift

class Store {
    
    func emptyStore() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func storeLocations(locations: [String]) {
        for location in locations {
            let l = Location()
            l.name = location
            let realm = try! Realm()
            try! realm.write {
                realm.add(l)
            }
        }
    }
    
    func storeNetworks(networks: [String]) {
        for network in networks {
            let n = Network()
            n.name = network
            let realm = try! Realm()
            try! realm.write {
                realm.add(n)
            }
        }
    }
    
    static func findLocation(location: String) -> Location? {
        let predicate = NSPredicate(format: "name = %@", location)
        let realm = try! Realm()
        return realm.objects(Location.self).filter(predicate).first
    }
    
    static func findNetwork(network: String) -> Network? {
        let predicate = NSPredicate(format: "name = %@", network)
        let realm = try! Realm()
        return realm.objects(Network.self).filter(predicate).first
    }
}
