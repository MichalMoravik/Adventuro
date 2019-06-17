//
//  DatabaseProtocol.swift
//  Adventuro
//
//  Created by Michal Moravík on 13/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation

protocol DatabasProtocol {
    
    func getLocationDataByID(locationID:String, completionBlock: @escaping (_ locationName:String, _ locationDescription:String) -> Void)
    
    func getLocationIDFromAdventure(userID: String, adventureID:String, completionBlock: @escaping (_ locationID:String) -> Void)
    
    func saveNewAdventure(locationID:String, usersNotes:String, userID:String, completionBlock: @escaping (_ newAdventureDocumentID: String?) -> Void)
    
    func retrieveAdventure(userID: String, adventureID: String, completionBlock: @escaping (_ usersNotes: String?) -> Void)
    
    func getAllAdventuresFromDB(userID:String, completionBlock: @escaping (_ allAdventuresArray: [Adventure]) -> Void)
    
    func getLocationNameFromID(locationID:String, completionBlock: @escaping (_ locationName: String) -> Void)
}
