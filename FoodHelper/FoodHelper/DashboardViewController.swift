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
            styleUI()
            loadNGOInfo()
            loadStats()
            loadUrgentDonation()
        }

        // MARK: - UI Styling
        func styleUI() {
            let views = [urgentView, PendingView, PickedView, TotalView, WelcomeView]
            views.forEach { view in
                view?.layer.cornerRadius = 16
                view?.layer.shadowColor = UIColor.black.cgColor
                view?.layer.shadowOpacity = 0.15
                view?.layer.shadowOffset = CGSize(width: 0, height: 4)
                view?.layer.shadowRadius = 8
            }
        }

        // MARK: - Load NGO Info
        func loadNGOInfo() {
            db.collection("users").document(uid).getDocument { snap, _ in
                guard let data = snap?.data() else { return }
                self.ngoNameLabel.text = data["name"] as? String ?? "NGO"
                let verified = data["verified"] as? Bool ?? false
                self.verifiedLabel.text = verified ? "Verified NGO" : "Not Verified ✖"
                self.verifiedLabel.textColor = verified ? .systemGreen : .systemRed
            }
        }

        // MARK: - Load Stats
        func loadStats() {
            // Picked count
            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: uid)
                .whereField("status", isEqualTo: "picked")
                .getDocuments { snap, _ in
                    self.pickedCountLabel.text = "\(snap?.documents.count ?? 0)"
                }

            // Pending count
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snap, _ in
                    self.pendingCountLabel.text = "\(snap?.documents.count ?? 0)"
                }

            // Total donations
            db.collection("donations").getDocuments { snap, _ in
                self.totalCountLabel.text = "\(snap?.documents.count ?? 0)"
            }
        }

        // MARK: - Load Urgent Donation
        func loadUrgentDonation() {
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snap, _ in
                    guard let docs = snap?.documents, !docs.isEmpty else {
                        self.urgentView.isHidden = true
                        return
                    }

                    let today = Date()
                    let urgent = docs.first { doc in
                        if let expiryTs = doc["expiryDate"] as? Timestamp {
                            let expiryDate = expiryTs.dateValue()
                            return Calendar.current.isDateInToday(expiryDate)
                        }
                        return false
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
                        self.urgentExpiryLabel.text = "Expires: \(formatter.string(from: ts.dateValue()))"
                    }
                }
        }
    }
