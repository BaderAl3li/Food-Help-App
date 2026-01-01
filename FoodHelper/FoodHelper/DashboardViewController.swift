//
//  DashboardViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DashboardViewController: UIViewController {

    
    @IBOutlet weak var ngoNameLabel: UILabel!
        @IBOutlet weak var verifiedLabel: UILabel!

        @IBOutlet weak var pendingLabel: UILabel!
        @IBOutlet weak var pickedLabel: UILabel!
        @IBOutlet weak var totalLabel: UILabel!

    
    @IBOutlet weak var PendingView: UIView!
    @IBOutlet weak var PickedView: UIView!
    @IBOutlet weak var TotalView: UIView!
    @IBOutlet weak var WelcomeView: UIView!
    
    let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid

        override func viewDidLoad() {
            super.viewDidLoad()
            loadNGOInfo()
            loadStats()
            
            PendingView.layer.cornerRadius = 10
            TotalView.layer.cornerRadius = 10
            PickedView.layer.cornerRadius = 10
            WelcomeView.layer.cornerRadius = 10
            
            WelcomeView.layer.borderWidth = 1
            WelcomeView.layer.borderColor = UIColor.purple.cgColor

        }

        func loadNGOInfo() {
            db.collection("users").document(uid).getDocument { snap, _ in
                guard let data = snap?.data() else { return }

                self.ngoNameLabel.text = data["org name"] as? String ?? "NGO"
                let approved = data["status"] as? String == "approved"
                self.verifiedLabel.text = approved ? "Verified NGO" : "Not Verified"
                self.verifiedLabel.textColor = approved ? .systemGreen : .systemRed
            }
        }

        func loadStats() {

            // Pending
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snap, _ in
                    self.pendingLabel.text = "\(snap?.count ?? 0)"
                }

            // Picked by this NGO
            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: "New Org")
                .whereField("status", isEqualTo: "picked")
                .getDocuments { snap, _ in
                    self.pickedLabel.text = "\(snap?.count ?? 0)"
                }

            // Total
            db.collection("donations")
                .getDocuments { snap, _ in
                    self.totalLabel.text = "\(snap?.count ?? 0)"
                }
        }
    }
