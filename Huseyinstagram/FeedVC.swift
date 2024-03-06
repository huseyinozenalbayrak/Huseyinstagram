//
//  FeedVC.swift
//  Huseyinstagram
//
//  Created by Hüseyin Özen Albayrak on 2.08.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.postImage.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.docIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                if let error1 = error?.localizedDescription as? String {
                    print(error1)
                }
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    //QuerySnapshotlar içerisinde çektiğim koleksiyondaki dokumanlar bana veriliyor. Ben de bunları loop'a alacagim sonra da tüm istediğim işlemleri yapacağım
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                            if let postComment = document.get("postComment") as? String {
                                self.userCommentArray.append(postComment)
                                if let likes = document.get("likes") as? Int {
                                    self.likeArray.append(likes)
                                    if let imageUrl = document.get("imageUrl") as? String {
                                        self.userImageArray.append(imageUrl)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
