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
    
    // Loads pending users
    func loadPendingUser() {
            Firestore.firestore()
                .collection("users")
                .whereField("status", isEqualTo: "pending")
                .whereField("role", isEqualTo:
                    "donor")
                .limit(to: 1)
                .getDocuments { snapshot, error in

                    if let error = error {
                                    return
                                }

                                guard let doc = snapshot?.documents.first else {
                                    self.showNoRequestsState()
                                    return
                                }

                                let data = doc.data()
                                //loads users
                                
                                self.currentUserId = doc.documentID
                                self.fNameLabel?.text = data["donor name"] as? String ?? "-"
                                self.emailLabel?.text = data["email"] as? String ?? "-"
                                self.numberLabel?.text = data["number"] as? String ?? "-"

                }
        }
    // No pending status in the database
    func showNoRequestsState() {
        fNameLabel?.text = "No pending"
        emailLabel?.text = ""
        numberLabel?.text = ""

        }
    
    //changes status to approve and updates the database
    @IBAction func approveTapped(_ sender: Any) {
        updateStatus("approved")
    }
    
    //deletes user from database
    @IBAction func declineTapped(_ sender: Any) {
        deleteUser()
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
    
    func deleteUser(){
        guard let userId = currentUserId else {return}
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .delete {_ in self.loadPendingUser()
            }
    }
    

}

