//
//  UploadVC.swift
//  Huseyinstagram
//
//  Created by Hüseyin Özen Albayrak on 2.08.2023.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadButton.isEnabled = false
        postImage.isUserInteractionEnabled = true
        let imageTapGR = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        postImage.addGestureRecognizer(imageTapGR)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        uploadButton.isEnabled = true
    }

    @IBAction func uploadClicked(_ sender: Any) {
        let storageRef = Storage.storage().reference()
        let mediaFolder = storageRef.child("media")
        
        if let imageData = postImage.image?.jpegData(compressionQuality: 0.6) {
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(imageData, metadata: nil) { metaData, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                            if let imageUrl = url?.absoluteString {
                                //DATABASE
                                let firestoreDatabase = Firestore.firestore()
                                let firestoreReference : DocumentReference
                                let firestorePost = ["imageUrl" : imageUrl, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                                
                                firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    } else {
                                        self.commentText.text = ""
                                        self.postImage.image = UIImage(named: "select")
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}
