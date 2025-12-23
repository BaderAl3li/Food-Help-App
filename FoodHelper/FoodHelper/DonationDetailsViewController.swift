//
//  DonationDetailsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 23/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DonationDetailsViewController: UIViewController {
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var donorNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    let db = Firestore.firestore()
        var donationId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptButton.layer.cornerRadius = 12
                declineButton.layer.cornerRadius = 12

                fetchDonationDetails()
      
    }
    
    // 🔥 FETCH SINGLE DONATION
       func fetchDonationDetails() {

           db.collection("donations").document(donationId).getDocument { snapshot, error in

               if let error = error {
                   print(error)
                   return
               }

               guard let data = snapshot?.data() else { return }

               self.foodNameLabel.text = data["name"] as? String
               self.quantityLabel.text = "Quantity: \(data["plates"] as? Int ?? 0) Plates"
               self.expiresLabel.text = "Expires: \(data["expires"] as? String ?? "")"
               self.postedLabel.text = "Posted: \(data["postedAt"] as? String ?? "")"
               self.typeLabel.text = "Type: \(data["type"] as? String ?? "")"

               self.donorNameLabel.text = data["market"] as? String
               self.phoneLabel.text = data["phone"] as? String
               self.addressLabel.text = data["address"] as? String
               self.distanceLabel.text = "\(data["distance"] as? String ?? "") away"
               self.notesLabel.text = data["notes"] as? String

               if let url = data["imageUrl"] as? String {
                   self.loadImage(url: url)
               }
           }
       }

       func loadImage(url: String) {
           guard let imageURL = URL(string: url) else { return }
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: imageURL) {
                   DispatchQueue.main.async {
                       self.foodImage.image = UIImage(data: data)
                   }
               }
           }
       }

       // 🔥 ACCEPT & SCHEDULE
       @IBAction func acceptTapped(_ sender: UIButton) {

           guard let ngoId = Auth.auth().currentUser?.uid else { return }

           db.collection("donations").document(donationId).updateData([
               "state": "accepted",
               "acceptedBy": ngoId,
               "acceptedAt": FieldValue.serverTimestamp()
           ]) { error in
               if error == nil {
                   self.navigationController?.popViewController(animated: true)
               }
           }
       }

       @IBAction func declineTapped(_ sender: UIButton) {
           navigationController?.popViewController(animated: true)
       }
   }
