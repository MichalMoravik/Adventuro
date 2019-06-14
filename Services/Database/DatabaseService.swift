//
//  DatabaseService.swift
//  Adventuro
//
//  Created by Michal Moravík on 13/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
    
    func saveNewAdventure(locationID:String, usersNotes:String, userID:String, completionBlock: @escaping (_ newAdventureDocumentID: String?, _ success:Bool) -> Void) {
        var docRef: DocumentReference? = nil
        docRef = db.collection("users").document(userID).collection("adventures").addDocument(data: [
            "locationID": locationID,
            "notes": usersNotes
        ]) { error in
            if let error = error {
                print("Error while adding new adventure to firestore: \(error)")
            } else {
                if let docRef = docRef {
                    completionBlock(docRef.documentID, true)
                } else {
                    print("Could not get a reference to new adventure document while adding new adventure")
                    completionBlock(nil, false)
                }
            }
        }
    }
}
