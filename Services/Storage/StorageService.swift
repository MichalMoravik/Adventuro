//
//  StorageService.swift
//  Adventuro
//
//  Created by Michal Moravík on 13/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    let storage = Storage.storage() // storage object
    static let shared = StorageService()
    
    func getLocationImageFromDB() {
        //let storageRef = storage.reference().child("locations")
        
    }
    
    func saveUsersAdventurePhoto(userID:String, takenPhoto:UIImage, adventureID:String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let storageRef = storage.reference().child("usersPhotos/\((userID))/\(adventureID)")
        let jpegToSave = takenPhoto.jpegData(compressionQuality: 1.0)
        
        storageRef.putData(jpegToSave!, metadata: nil, completion: { (metadata, error) in
            if error == nil{
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        })
    }
}
