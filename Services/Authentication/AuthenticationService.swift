//
//  FirebaseAuthService.swift
//  Adventuro
//
//  Created by Michal Moravík on 08/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationService:AuthenticationProtocol {
    static let shared = AuthenticationService()
    
    var currentUser = Auth.auth().currentUser
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }    
}
