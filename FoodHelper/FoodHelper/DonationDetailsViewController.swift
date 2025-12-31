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
    
        @IBOutlet weak var quantity: UILabel!
        
        @IBOutlet weak var `Type`: UILabel!
    
        @IBOutlet weak var doner: UILabel!
        @IBOutlet weak var phoneNumber: UILabel!
    
        @IBOutlet weak var Location: UILabel!
    
        @IBOutlet weak var Note: UILabel!
    
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            expiryLabel.text = "⏰ Expires: \(dateFormatter.string(from: donation.expiryDate))"
        }

        @IBAction func acceptTapped(_ sender: UIButton) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            db.collection("donations").document(donation.id).updateData([
                "status": "accepted",
                "acceptedBy": uid
            ]) { error in
                if let error = error {
                    print("Error accepting donation: \(error)")
                } else {
                    let alert = UIAlertController(title: "Success", message: "Donation accepted successfully.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            }
        }
    }
