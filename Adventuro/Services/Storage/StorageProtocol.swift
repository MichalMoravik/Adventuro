//
//  StorageProtocol.swift
//  Adventuro
//
//  Created by Michal Moravík on 17/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import UIKit

protocol StorageProtocol {
    func saveUsersAdventurePhoto(userID:String, takenPhoto:UIImage, adventureID:String, completionBlock: @escaping (_ success: Bool) -> Void)
    
    func retrieveUsersAdventurePhoto(userID:String, adventureID: String, completionBlock: @escaping (_ photo: UIImage?) -> Void)
    
    func retrieveLocationImage(locationID:String,completionBlock: @escaping (_ photo: UIImage?) -> Void)
}
