//
//  AdventureToAddViewController.swift
//  Adventuro
//
//  Created by Michal Moravík on 12/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit

class AdventureToAddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var locationIDFromQR: String?
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var adventureButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    var takenPhoto: UIImage!
    let currentUser = AuthenticationService.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationDescription.isEditable = false
        adventureButton.isEnabled = false
        adventureButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 0.6)
        
        if currentUser != nil {
            print("Automatically signed in user: \(currentUser!.email)")
        } else {
            // neviem
        }
        
        if let locationIDFromQR = locationIDFromQR {
            populateLocationFields(locationID: locationIDFromQR)
        } else {
            print("Could not get locationIDFromQR")
        }
    }
    
    func populateLocationFields(locationID:String) {
        
        let child = SpinnerViewController()
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        
        DatabaseService.shared.getLocationDataByID(locationID: locationID) { (locationName,locationDescription) in
            self.locationName.text = locationName
            self.locationDescription.text = locationDescription
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
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
        
        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DatabaseService.shared.saveNewAdventure(locationID: locationIDFromQR!, usersNotes: "dummy", userID: (currentUser?.uid)!) { (newAdventureDocumentID, success) in
            if newAdventureDocumentID != nil && success == true {
                StorageService.shared.saveUsersAdventurePhoto(userID: (self.currentUser?.uid)!, takenPhoto: self.takenPhoto, adventureID: newAdventureDocumentID!) {(success) in
                    if success == true {
                        print("everything should be saved... go and check!")
                        
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
