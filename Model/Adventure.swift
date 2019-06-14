//
//  Adventure.swift
//  Adventuro
//
//  Created by Michal Moravík on 14/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation

class Adventure {
    var locationName: String
    var adventureID: String
    
    init(locationName:String, adventureID:String) {
        self.locationName = locationName
        self.adventureID = adventureID
    }
}
