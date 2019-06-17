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
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func adventureButtonPressed(_ sender: Any) {
        SpinnerViewController.shared.startSpinner(targetViewController: self)
        self.adventureButton.isEnabled = false
        let usersNotesToSave = notesTextView.text!
        
        DatabaseService.shared.saveNewAdventure(locationID: locationIDFromQR, usersNotes: usersNotesToSave, userID: (currentUser?.uid)!) { (newAdventureDocumentID) in
            if let newAdventureDocumentID = newAdventureDocumentID  {
                StorageService.shared.saveUsersAdventurePhoto(userID: (self.currentUser?.uid)!, takenPhoto: self.takenPhoto, adventureID: newAdventureDocumentID) {(success) in
                    if success == true {
                        SpinnerViewController.shared.stopSpinner()
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
        
        takenPhoto = photo.resized(toWidth: self.view.frame.size.width)
        print("newPhoto has size: \(takenPhoto.size)")
        changeViewAfterPhotoAdded()
    }
    
    func changeViewAfterPhotoAdded() {
        addPhotoButton.setTitle("Retake photo", for: .normal)
        addPhotoButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 0.595703125)
        adventureButton.isEnabled = true
        adventureButton.backgroundColor = #colorLiteral(red: 1, green: 0.2917113326, blue: 0.3214161505, alpha: 1)
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

