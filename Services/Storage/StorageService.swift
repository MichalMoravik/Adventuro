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
}

/* extension for storing cropped photo to the storage so it does not take unnecessary big space
extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRation = CGFloat(self.size.width / self.size.height)
        return widthRation
    }
}*/
