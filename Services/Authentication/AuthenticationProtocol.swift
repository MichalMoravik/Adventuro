//
//  AuthenticationProtocol.swift
//  Adventuro
//
//  Created by Michal Moravík on 12/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    
    func signIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void)
}
