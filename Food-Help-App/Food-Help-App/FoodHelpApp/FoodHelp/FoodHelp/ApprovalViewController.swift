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

                    if let error = error {
                                    print("❌ Firestore error:", error)
                                    return
                                }

                                guard let doc = snapshot?.documents.first else {
                                    print("ℹ️ No pending users found")
                                    self.showNoRequestsState()
                                    return
                                }

                                let data = doc.data()
                                print("✅ Loaded user:", data)

                                self.currentUserId = doc.documentID

                                self.fNameLabel?.text = data["fName"] as? String ?? "-"
                                self.emailLabel?.text = data["email"] as? String ?? "-"
                                self.numberLabel?.text = data["number"] as? String ?? "-"

                }
        }
    
    func showNoRequestsState() {
        fNameLabel?.text = "No pending"
        emailLabel?.text = ""
        numberLabel?.text = ""

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

