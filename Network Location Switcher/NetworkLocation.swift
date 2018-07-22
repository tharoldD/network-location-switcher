//
//  NetworkLocation.swift
//  Network Location Switcher
//
//  Created by Harold Turyasingura on 22/07/2018.
//  Copyright © 2018 Harold Turyasingura. All rights reserved.
//

import Foundation
import RealmSwift

class NetworkLocation: Object {
    @objc dynamic var network: Network?
    @objc dynamic var location: Location?
}
