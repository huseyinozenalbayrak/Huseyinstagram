//
//  CustomCell.swift
//  Huseyinstagram
//
//  Created by Hüseyin Özen Albayrak on 6.08.2023.
//

import UIKit
import Firebase

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var docIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func likeClicked(_ sender: Any) {
        
        let firestore = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestore.collection("Posts").document(docIdLabel.text!).setData(likeStore, merge: true)
        }
    }
}
