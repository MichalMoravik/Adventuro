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
    let compressionQuality: CGFloat = 0.5 // medium
    
    func getLocationImageFromDB() {
        //let storageRef = storage.reference().child("locations")
        
    }
    
    func saveUsersAdventurePhoto(/*view: UIView,*/userID:String, takenPhoto:UIImage, adventureID:String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let storageRef = storage.reference().child("usersPhotos/\((userID))/\(adventureID)")
       // let cropImageRatio = takenPhoto.getCropRatio()
       // let newWidthBasedOnControllerWidth = view.frame.width / cropImageRatio
        
        let jpegToSave = takenPhoto.jpegData(compressionQuality: compressionQuality)
        
        storageRef.putData(jpegToSave!, metadata: nil, completion: { (metadata, error) in
            if error == nil{
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        })
    }
    
    func retrieveUsersAdventurePhoto(userID:String, adventureID: String, completionBlock: @escaping (_ photo: UIImage?) -> Void) {
        let storageRef = storage.reference().child("usersPhotos/\(userID)/\(adventureID)")
        
        storageRef.getData(maxSize: 100 * 1024 * 1024) { data, error in
            if let error = error {
                print("Could not retrieve image from storage error: \(error)")
            } else {
                let photo = UIImage(data: data!)
                completionBlock(photo)
            }
        }
    }
    
    func retrieveLocationImage(locationID:String,completionBlock: @escaping (_ photo: UIImage?) -> Void) {
        let storageRef = storage.reference().child("locations/\(locationID)")
        storageRef.getData(maxSize: 100 * 1024 * 1024) { data, error in
            if let error = error {
                print("Could not retrieve image from storage error: \(error)")
            } else {
                let photo = UIImage(data: data!)
                completionBlock(photo)
            }
        }
    }
}



