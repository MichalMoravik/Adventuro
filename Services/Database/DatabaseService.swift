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
                print("DatabaseService: Could not find location document")
            }
        }
    }
    
    func getLocationIDFromAdventure(userID: String, adventureID:String, completionBlock: @escaping (_ locationID:String) -> Void) {
        let docRef = db.collection("users").document(userID).collection("adventures").document(adventureID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let locationID = document.get("locationID")
                completionBlock(locationID as! String)
            } else {
                print("DatabaseService: Could not find adventure document")
            }
        }
    }
    
    func saveNewAdventure(locationID:String, usersNotes:String, userID:String, completionBlock: @escaping (_ newAdventureDocumentID: String?) -> Void) {
        var docRef: DocumentReference? = nil
        docRef = db.collection("users").document(userID).collection("adventures").addDocument(data: [
            "locationID": locationID,
            "notes": usersNotes
        ]) { error in
            if let error = error {
                print("Error while adding new adventure to firestore: \(error)")
            } else {
                if let docRef = docRef {
                    completionBlock(docRef.documentID)
                } else {
                    print("Could not get a reference to new adventure document while adding new adventure")
                }
            }
        }
    }
    
    func retrieveAdventure(userID: String, adventureID: String, completionBlock: @escaping (_ usersNotes: String?) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(userID).collection("adventures").document(adventureID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let usersNotes = document.get("notes") as! String
                completionBlock(usersNotes)
            } else {
                print("DatabaseService: Could not find adventure document")
            }
        }
    }
    
    // to populate the tableView
    func getAllAdventuresFromDB(userID:String, completionBlock: @escaping (_ allAdventuresArray: [Adventure]) -> Void) {
        var adventures: [Adventure] = []
        let adventuresCollection = Firestore.firestore().collection("users").document(userID).collection("adventures")
        
        let dispatchGroup = DispatchGroup()
        adventuresCollection.addSnapshotListener { querySnapshot, error in
            for adventure in querySnapshot!.documents{
                let adventureID = adventure.documentID
                let locationIDFromAdventure = adventure.get("locationID") //data()["locationID"]
                
                print("vnutri for each")
                
                print("adventureID is: \(adventureID)")
                print("locationID in adventure is: \(locationIDFromAdventure as! String)")
            
                dispatchGroup.enter()
                self.getLocationNameFromID(locationID: locationIDFromAdventure as! String) {(locationName) in
                    let adventure = Adventure(locationName: locationName, adventureID: adventureID)
                    adventures.append(adventure)
                    print("new adventure object: \(adventure.adventureID) and place \(adventure.locationName)")
                    dispatchGroup.leave()
                }
            } // end for each adventure document
            dispatchGroup.notify(queue: .main) {
                print("vonku z for eachu")
                completionBlock(adventures)
            }
            
        }
    }
    
    func getLocationNameFromID(locationID:String, completionBlock: @escaping (_ locationName: String) -> Void) {
        let locationDocument = Firestore.firestore().collection("locations").document(locationID)
        locationDocument.getDocument { (document, error) in
            if let location = document, location.exists {
                let locationName = location.get("name") as! String
                completionBlock(locationName)
            } else {
                print("getLocationNameFromID: Could not find location document")
            }
        }
    }
}

