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
        titleLabel.text = donation.title
        expiryLabel.text = "Expires: \(donation.expiryDate)"


    }
    @IBAction func acceptTapped(_ sender: UIButton) {
            let uid = Auth.auth().currentUser!.uid

            db.collection("donations").document(donation.id)
                .updateData([
                    "status": "accepted",
                    "acceptedBy": uid
                ]) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }
