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
        loadUrgentDonation()

    }
    
    func styleUI() {
            urgentView.layer.cornerRadius = 16
            urgentView.layer.shadowColor = UIColor.black.cgColor
            urgentView.layer.shadowOpacity = 0.15
            urgentView.layer.shadowOffset = CGSize(width: 0, height: 4)
            urgentView.layer.shadowRadius = 8
        
        PendingView.layer.cornerRadius = 16
        PickedView.layer.cornerRadius = 16
        TotalView.layer.cornerRadius = 16
        WelcomeView.layer.cornerRadius = 16
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

                   guard let docs = snap?.documents else {
                       self.urgentView.isHidden = true
                       return
                   }

                   let today = Date()

                   let urgent = docs.first {
                       let expiry = ($0["expiryDate"] as? Timestamp)?.dateValue() ?? Date()
                       return Calendar.current.isDateInToday(expiry)
                   }

                   guard let doc = urgent else {
                       self.urgentView.isHidden = true
                       return
                   }

                   self.urgentView.isHidden = false
                   self.urgentTitleLabel.text = doc["title"] as? String

                   if let ts = doc["expiryDate"] as? Timestamp {
                       let formatter = DateFormatter()
                       formatter.dateStyle = .medium
                       formatter.timeStyle = .short
                   }
               }
       }
   }
