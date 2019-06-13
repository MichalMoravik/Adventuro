//
//  DatabaseService.swift
//  Adventuro
//
//  Created by Michal Moravík on 13/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let shared = DatabaseService()
    let db = Firestore.firestore()
    
    func getLocationDataByID(locationID:String, completionBlock: @escaping (_ locationName:String, _ locationDescription:String) -> Void) {
        let docRef = db.collection("locations").document(locationID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
               // let data = document.data().map(String.init(describing:)) ?? "nil"
                let locationName = document.get("name")
                let locationDescription = document.get("description")
                completionBlock(locationName as! String, locationDescription as! String)
            } else {
                print("DatabaseService: Could not get data")
            }
        }
    }
}
