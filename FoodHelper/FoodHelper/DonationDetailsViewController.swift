//
//  DonationDetailsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DonationDetailsViewController: UIViewController {
    
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var expiryLabel: UILabel!
        @IBOutlet weak var acceptButton: UIButton!
    
        var donation: Donation!
        let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
               displayDonationDetails()
           }

           private func setupUI() {
               acceptButton.layer.cornerRadius = 8
               acceptButton.backgroundColor = .systemGreen
               acceptButton.setTitleColor(.white, for: .normal)
           }

           private func displayDonationDetails() {
               titleLabel.text = donation.title

               // Format Firestore Timestamp to readable string
               if let expiry = donation.expiryDate {
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateStyle = .medium
                   dateFormatter.timeStyle = .short
                   expiryLabel.text = "⏰ Expires: \(dateFormatter.string(from: expiry.dateValue()))"
               } else {
                   expiryLabel.text = "⏰ Expiry date not available"
               }
           }

           @IBAction func acceptTapped(_ sender: UIButton) {
               guard let uid = Auth.auth().currentUser?.uid else { return }

               db.collection("donations").document(donation.id)
                   .updateData([
                       "status": "accepted",
                       "acceptedBy": uid
                   ]) { error in
                       if let error = error {
                           print("Error accepting donation: \(error)")
                       } else {
                           // Optional: show success alert
                           let alert = UIAlertController(title: "Success",
                                                         message: "Donation accepted successfully.",
                                                         preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                               self.navigationController?.popViewController(animated: true)
                           })
                           self.present(alert, animated: true)
                       }
                   }
           }
       }
