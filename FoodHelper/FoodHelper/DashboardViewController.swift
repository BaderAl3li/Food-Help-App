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

        @IBOutlet weak var pendingCountLabel: UILabel!
        @IBOutlet weak var pickedCountLabel: UILabel!
        @IBOutlet weak var totalCountLabel: UILabel!

    
    @IBOutlet weak var PendingView: UIView!
    @IBOutlet weak var PickedView: UIView!
    @IBOutlet weak var TotalView: UIView!
    @IBOutlet weak var WelcomeView: UIView!
    
    let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid

        override func viewDidLoad() {
            super.viewDidLoad()
            loadNGOInfo()
            loadNGOInfo()
                        
            loadStats()
        }

    func loadNGOInfo() {
            db.collection("users").document(uid).getDocument { snap, _ in
                guard let data = snap?.data() else { return }
                self.ngoNameLabel.text = data["org name"] as? String ?? "NGO"
                let approved = (data["status"] as? String) == "approved"
                self.verifiedLabel.text = approved ? "Verified NGO" : "Not Verified"
                self.verifiedLabel.textColor = approved ? .systemGreen : .systemRed
            }
        }

        func loadStats() {
            db.collection("donations").whereField("status", isEqualTo: "pending").getDocuments { snap, _ in
                self.pendingCountLabel.text = "\(snap?.count ?? 0)"
            }

            db.collection("donations").whereField("acceptedBy", isEqualTo: self.uid).whereField("status", isEqualTo: "picked").getDocuments { snap, _ in
                self.pickedCountLabel.text = "\(snap?.count ?? 0)"
            }

            db.collection("donations").getDocuments { snap, _ in
                self.totalCountLabel.text = "\(snap?.count ?? 0)"
            }
        }
    }
