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
//  https://stackoverflow.com/a/4481019/7715706

import Cocoa
import RealmSwift

class ViewController: NSViewController {
    @IBOutlet weak var networksPopUp: NSPopUpButton!
    @IBOutlet weak var locationsPopUp: NSPopUpButton!
    
    let shell = Shell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let locations = realm.objects(Location.self)
        let networks = realm.objects(Network.self)
        
        for location in locations {
            locationsPopUp.addItem(withTitle: location.name)
        }
        for network in networks {
            networksPopUp.addItem(withTitle: network.name)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func setLocationClicked(_ sender: Any) {
        if let selectedLocation = locationsPopUp.titleOfSelectedItem {
            
            let networkLocation = NetworkLocation()
            let location = Store.findLocation(location: selectedLocation)
            let network = Store.findNetwork(network: networksPopUp.titleOfSelectedItem!)
            
            networkLocation.location = location
            networkLocation.network = network
            
            let realm = try! Realm()
            try! realm.write{
                realm.add(networkLocation)
            }
            
        }
    }
    
    func switchLocation() {
        if let selectedLocation = locationsPopUp.titleOfSelectedItem {
            let (output, terminationStatus) = shell.setCurrentLocation(location: selectedLocation)
            if terminationStatus == 0 {
                let commandResponse = output?.components(separatedBy: CharacterSet.newlines)
                
                for var response in commandResponse! {
                    response = response.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    print(response)
                    // TODO: Use this response to maybe show a popup alert of
                    // success or something
                }
            }
        }
    }
    
}
