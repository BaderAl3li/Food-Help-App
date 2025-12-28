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

        @IBOutlet weak var urgentView: UIView!
        @IBOutlet weak var urgentTitleLabel: UILabel!
    
    let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNGOInfo()
        loadStats()
        loadUrgentDonation()

    }
    func loadNGOInfo() {
           db.collection("users").document(uid).getDocument { snap, _ in
               guard let data = snap?.data() else { return }

               self.ngoNameLabel.text = data["name"] as? String ?? "NGO"
               let verified = data["verified"] as? Bool ?? false

               self.verifiedLabel.text = verified ? "Verified NGO" : "Not Verified ✖"
               self.verifiedLabel.textColor = verified ? .systemGreen : .systemRed
           }
       }

       func loadStats() {
           db.collection("donations")
               .whereField("acceptedBy", isEqualTo: uid)
               .getDocuments { snap, _ in
                   let picked = snap?.documents.filter {
                       $0["status"] as? String == "picked"
                   }.count ?? 0
                   self.pickedCountLabel.text = "\(picked)"
               }

           db.collection("donations")
               .whereField("status", isEqualTo: "pending")
               .getDocuments { snap, _ in
                   self.pendingCountLabel.text = "\(snap?.documents.count ?? 0)"
               }

           db.collection("donations").getDocuments { snap, _ in
               self.totalCountLabel.text = "\(snap?.documents.count ?? 0)"
           }
       }

       func loadUrgentDonation() {
           db.collection("donations")
               .whereField("status", isEqualTo: "pending")
               .getDocuments { snap, _ in
                   guard let docs = snap?.documents else { return }
                   let today = Date()

                   let urgent = docs.first {
                       let date = ($0["expiryDate"] as? Timestamp)?.dateValue() ?? Date()
                       return Calendar.current.isDateInToday(date)
                   }

                   self.urgentView.isHidden = urgent == nil
                   self.urgentTitleLabel.text = urgent?["title"] as? String ?? ""
               }
       }
   }
