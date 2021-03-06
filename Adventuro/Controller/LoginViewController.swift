//
//  LoginViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 08/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceholderColor(emailTextField: emailTextField, passwordTextField: passwordTextField)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        AuthenticationService.shared.signIn(email: email, password: password) {[weak self] (success) in
            if (success) {
                print("User with this email: \(email) was successfuly signed in!")
                self!.performSegue(withIdentifier: "showTabBarSegue", sender: nil)
            } else {
                print("User could not be signed in!")
            }
        }
    }
    
    func setPlaceholderColor(emailTextField: UITextField, passwordTextField: UITextField) {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Passwrod", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
}





















/*if let tabbar = (self?.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController) {
 self?.present(tabbar, animated: true, completion: nil)
 }*/
