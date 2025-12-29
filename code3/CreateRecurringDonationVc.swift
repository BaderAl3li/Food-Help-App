//
//  CreateRecurringDonationVc.swift
//  code3
//
//  Created by BP-19-114-09 on 24/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


    
    final class CreateRecurringDonationVC: UIViewController {
        
        @IBOutlet weak var resumeButton: UIButton!
        @IBOutlet weak var pauseButton: UIButton!
        @IBOutlet weak var createButton: UIButton!
        @IBOutlet weak var EditButton: UIButton!

        
        @IBOutlet weak var infoLabel: UILabel!

        @IBOutlet weak var donationTypeField: UITextField!
        @IBOutlet weak var foodTypeField: UITextField!
        @IBOutlet weak var quantityField: UITextField!
        @IBOutlet weak var preferredCharityField: UITextField!
        @IBOutlet weak var scheduleIntervalField: UITextField!
        @IBOutlet weak var scheduleTimeField: UITextField!
        @IBOutlet weak var deliveryCompanyField: UITextField!
        @IBOutlet weak var finishButton: UIButton!
        
        private let db = Firestore.firestore()
        
        
        override func viewDidLoad() {
            print("Current screen loaded, uid:", Auth.auth().currentUser?.uid ?? "nil")
            super.viewDidLoad()
            quantityField.keyboardType = .numberPad
            load()
        }
        

        @IBAction func finishTapped(_ sender: UIButton) {
            
            // make sure theyre all filled
            guard
                let donationType = donationTypeField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !donationType.isEmpty,
                let foodType = foodTypeField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !foodType.isEmpty,
                let quantityText = quantityField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !quantityText.isEmpty,
                let preferredCharity = preferredCharityField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !preferredCharity.isEmpty,
                let scheduleInterval = scheduleIntervalField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !scheduleInterval.isEmpty,
                let scheduleTime = scheduleTimeField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !scheduleTime.isEmpty,
                let deliveryCompany = deliveryCompanyField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !deliveryCompany.isEmpty
            else {
                showAlert("Please fill in all fields before continuing.")
                return
            }

            
            print("Finish tapped")
            guard let uid = Auth.auth().currentUser?.uid else {
                showAlert("Not signed in")
                return
            }
            print("UID:", Auth.auth().currentUser?.uid ?? "nil")
            
            let quantity = Int(quantityField.text ?? "") ?? 0
            
            let ref = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")

            ref.getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                
                let dataToSave: [String: Any] = [
                    "donationType": self.donationTypeField.text ?? "",
                    "foodType": self.foodTypeField.text ?? "",
                    "quantity": quantity,
                    "preferredCharity": self.preferredCharityField.text ?? "",
                    "scheduleInterval": self.scheduleIntervalField.text ?? "",
                    "scheduleTime": self.scheduleTimeField.text ?? "",
                    "deliveryCompany": self.deliveryCompanyField.text ?? "",
                    "status": "active",
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                
                ref.setData(dataToSave, merge: true) { error in
                    if let error = error {
                        print("Firestore save failed:", error)
                    } else {
                        print("Firestore save success")
                    }
                }
            }
        }

        private func load() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")
            
            ref.getDocument { [weak self] snapshot, _ in
                guard let self = self else { return }

                // If document is missing OR has no fields
                if snapshot?.exists == false || (snapshot?.data()?.isEmpty ?? true) {
                    DispatchQueue.main.async {
                      //  self.infoLabel.text = "No current recurring donations."
                    }
                    return
                }

                guard let data = snapshot?.data() else { return }

                DispatchQueue.main.async {
                    self.donationTypeField.text = data["donationType"] as? String
                    self.foodTypeField.text = data["foodType"] as? String
                    self.quantityField.text = "\(data["quantity"] as? Int ?? 0)"
                    self.preferredCharityField.text = data["preferredCharity"] as? String
                    self.scheduleIntervalField.text = data["scheduleInterval"] as? String
                    self.scheduleTimeField.text = data["scheduleTime"] as? String
                    self.deliveryCompanyField.text = data["deliveryCompany"] as? String
                }
            }
        }

        
        private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
            present(alert, animated: true)
        }

        @IBAction func DeleteDetails(_ sender: Any) {
            guard let uid = Auth.auth().currentUser?.uid else {
                showAlert("Not signed in")
                return
            }

            let ref = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")

            ref.delete { [weak self] error in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    if let error = error {
                        print("Failed to delete recurring donation:", error)
                        self.showAlert("Failed to delete. Please try again.")
                        return
                    }

                    print("Recurring donation deleted")

                    // Clear UI after delete – all optional now
                    self.infoLabel?.text = "No current recurring donations."
                    self.donationTypeField?.text = ""
                    self.foodTypeField?.text = ""
                    self.quantityField?.text = ""
                    self.preferredCharityField?.text = ""
                    self.scheduleIntervalField?.text = ""
                    self.scheduleTimeField?.text = ""
                    self.deliveryCompanyField?.text = ""
                }
            }
        }
    }
