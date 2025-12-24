//
//  ViewController.swift
//  FoodHelp
//
//  Created by BP-36-224-16 on 10/12/2025.
//

import UIKit
import Cloudinary
import SDWebImage
import FirebaseFirestore

class ApprovalViewController: UIViewController {
    
    @IBOutlet weak var fNameLabel: UILabel?
    
    @IBOutlet weak var lNameLabel: UILabel?
    
    @IBOutlet weak var emailLabel: UILabel?
    
    @IBOutlet weak var numberLabel: UILabel?
    var currentUserId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPendingUser()
    }
    
    func loadPendingUser() {
            Firestore.firestore()
                .collection("users")
                .whereField("status", isEqualTo: "pending")
                .limit(to: 1)
                .getDocuments { snapshot, error in

                    guard let doc = snapshot?.documents.first else {
                        self.showNoRequestsState()
                        return
                    }

                    let data = doc.data()
                    self.currentUserId = doc.documentID

                    self.fNameLabel.text = data["firstName"] as? String ?? "-"
                    self.lNameLabel.text = data["lastName"] as? String ?? "-"
                    self.emailLabel.text = data["email"] as? String ?? "-"
                    self.numberLabel.text = data["phone"] as? String ?? "-"
                }
        }
    
    func showNoRequestsState() {
            fNameLabel.text = "No pending"
            lNameLabel.text = ""
            emailLabel.text = ""
            numberLabel.text = ""
        }
    
    @IBAction func approveTapped(_ sender: Any) {
        updateStatus("approved")
    }
    
    @IBAction func declineTapped(_ sender: Any) {
        updateStatus("declined")
    }
    
    func updateStatus(_ status: String) {
           guard let userId = currentUserId else { return }

           Firestore.firestore()
               .collection("users")
               .document(userId)
               .updateData(["status": status])

           // Load next request automatically
           loadPendingUser()
       }
    

}

