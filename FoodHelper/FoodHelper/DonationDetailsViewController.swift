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
    
        @IBOutlet weak var quantityLabel: UILabel!
        
        @IBOutlet weak var typeLabel: UILabel!
    
        @IBOutlet weak var donorNameLabel: UILabel!
        @IBOutlet weak var phoneLabel: UILabel!
    
        @IBOutlet weak var addressLabel: UILabel!
    
        @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var itemInfoView: UIView!
    
    @IBOutlet weak var donerInfoView: UIView!
    var donation: Donation!
        let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Donation is nil?", donation == nil)
        setupUI()
        bindData()
        
           }

           func setupUI() {
               acceptButton.layer.cornerRadius = 8
               acceptButton.backgroundColor = .systemGreen
               acceptButton.setTitleColor(.white, for: .normal)
               
               itemInfoView.layer.borderWidth = 1
               itemInfoView.layer.borderColor = UIColor.purple.cgColor
               itemInfoView.layer.cornerRadius = 10
               
               donerInfoView.layer.borderWidth = 1
               donerInfoView.layer.borderColor = UIColor.purple.cgColor
               donerInfoView.layer.cornerRadius = 10
           }

    func bindData() {
            titleLabel.text = donation.title
            quantityLabel.text = "Quantity: \(donation.quantity)"
            typeLabel.text = "Type: \(donation.itemType)"

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            expiryLabel.text = "Expires: \(formatter.string(from: donation.expiryDate))"

            donorNameLabel.text = donation.donorName
            phoneLabel.text = "📞 \(donation.phoneNumber)"
            addressLabel.text =
                "Building \(donation.building), Road \(donation.road)"

            notesLabel.text = donation.description
        }

    @IBAction func acceptTapped(_ sender: UIButton) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snap, error in
            guard let data = snap?.data(),
                  let ngoName = data["org name"] as? String else { return }

            self.db.collection("donations")
                .document(self.donation.id)
                .updateData([
                    "status": "accepted",
                    "acceptedBy": ngoName
                ]) { error in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    }
    }
