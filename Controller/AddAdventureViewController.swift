//
//  AddAdventureViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 14/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class AddAdventureViewController: UIViewController, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    @IBOutlet weak var adventureButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    var takenPhoto: UIImage!
    let currentUser = AuthenticationService.shared.currentUser
    var locationIDFromQR: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        adventureButton.isEnabled = false
        adventureButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 0.6)
        
        if currentUser != nil {
            print("Automatically signed in user: \(currentUser!.email)")
        } else {
            // neviem
        }
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        // imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func adventureButtonPressed(_ sender: Any) {
        self.adventureButton.isEnabled = false
        let child = SpinnerViewController()
        let usersNotesToSave = notesTextView.text!
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DatabaseService.shared.saveNewAdventure(locationID: locationIDFromQR, usersNotes: usersNotesToSave, userID: (currentUser?.uid)!) { (newAdventureDocumentID, success) in
            if newAdventureDocumentID != nil && success == true {
                StorageService.shared.saveUsersAdventurePhoto(userID: (self.currentUser?.uid)!, takenPhoto: self.takenPhoto, adventureID: newAdventureDocumentID!) {(success) in
                    if success == true {
                        print("everything should be saved... go and check!")
                        
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                        
                        self.performSegue(withIdentifier: "addAdventureCompleteSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let photo = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        takenPhoto = photo
        // print out the image size as a test
        print(takenPhoto.size)
        
        
        changeViewAfterPhotoAdded()
    }
    
    func changeViewAfterPhotoAdded() {
        addPhotoButton.setTitle("Retake photo", for: .normal)
        addPhotoButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 0.595703125)
        adventureButton.isEnabled = true
        adventureButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 1)
    }
    
    
    
    }
    

