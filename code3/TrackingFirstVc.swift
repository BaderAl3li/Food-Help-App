//
//  RecurringFirstVc.swift
//  code3
//
//  Created by BP-36-201-24 on 29/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TrackingFirstVc: UIViewController {

    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var donationDetailsLabel: UILabel!
    
    
    
    private let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
            charityNameLabel.text = "Loading..."
            donationDetailsLabel.numberOfLines = 0
            donationDetailsLabel.lineBreakMode = .byWordWrapping
            donationDetailsLabel.text = ""
            loadRecurringDonation()
        }

        private func loadRecurringDonation() {
            // 1. Get current user
            guard let uid = Auth.auth().currentUser?.uid else {
                charityNameLabel.text = "Not logged in"
                donationDetailsLabel.text = ""
                return
            }

            // 2. Reference to the recurring donation document
            let docRef = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")

            // 3. Fetch data
            docRef.getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    self.charityNameLabel.text = "Error"
                    self.donationDetailsLabel.text = error.localizedDescription
                    return
                }

                guard let data = snapshot?.data(), !data.isEmpty else {
                    self.charityNameLabel.text = "No charity selected"
                    self.donationDetailsLabel.text = "You don't have an active recurring donation."
                    return
                }

                // 4. Read fields from Firestore
                let preferredCharity = data["preferredCharity"] as? String ?? "Unknown charity"
                let donationType = data["donationType"] as? String ?? "-"
                let deliveryCompany = data["deliveryCompany"] as? String ?? "-"
                let status = data["status"] as? String ?? "-"

                let startTimestamp = data["startDate"] as? Timestamp
                let endTimestamp = data["endDate"] as? Timestamp

                let startDate = startTimestamp?.dateValue()
                let endDate = endTimestamp?.dateValue()

                let formatter = DateFormatter()
                formatter.dateStyle = .medium

                // 5. Build the text for donationDetailsLabel
                var detailsParts: [String] = []

                detailsParts.append("Type: \(donationType)")
                detailsParts.append("Delivery: \(deliveryCompany)")

                if let startDate = startDate {
                    detailsParts.append("From: \(formatter.string(from: startDate))")
                }
                if let endDate = endDate {
                    detailsParts.append("To: \(formatter.string(from: endDate))")
                }

                detailsParts.append("Status: \(status)")

                // 6. Update labels on screen
                self.charityNameLabel.text = preferredCharity
                self.donationDetailsLabel.text = detailsParts.joined(separator: " • ")
            }
        }
    }
