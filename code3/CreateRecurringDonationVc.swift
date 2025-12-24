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
            print("👀 Current screen loaded, uid:", Auth.auth().currentUser?.uid ?? "nil")
            super.viewDidLoad()
            quantityField.keyboardType = .numberPad
            loadIfEditing()
        }
        

        @IBAction func finishTapped(_ sender: UIButton) {
            
            print("✅ Finish tapped")
            guard let uid = Auth.auth().currentUser?.uid else {
                showAlert("Not signed in")
                return
            }
            print("✅ UID:", Auth.auth().currentUser?.uid ?? "nil")
            
            let quantity = Int(quantityField.text ?? "") ?? 0
            
            let ref = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")
            
            // Predetermined dates
            let now = Date()
            let defaultEnd = Calendar.current.date(byAdding: .day, value: 30, to: now)!
            
            // Keep original dates if editing
            ref.getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                var startDate = now
                var endDate = defaultEnd
                
                if let data = snapshot?.data() {
                    if let ts = data["startDate"] as? Timestamp {
                        startDate = ts.dateValue()
                    }
                    if let ts = data["endDate"] as? Timestamp {
                        endDate = ts.dateValue()
                    }
                }
                
                let dataToSave: [String: Any] = [
                    "donationType": self.donationTypeField.text ?? "",
                    "foodType": self.foodTypeField.text ?? "",
                    "quantity": quantity,
                    "preferredCharity": self.preferredCharityField.text ?? "",
                    "scheduleInterval": self.scheduleIntervalField.text ?? "",
                    "scheduleTime": self.scheduleTimeField.text ?? "",
                    "deliveryCompany": self.deliveryCompanyField.text ?? "",
                    "startDate": Timestamp(date: startDate),
                    "endDate": Timestamp(date: endDate),
                    "status": "active",
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                
                print("📌 Writing to path:", ref.path)
                print("📦 Data to save:", dataToSave)
                
                ref.setData(dataToSave, merge: true) { error in
                    if let error = error {
                        print("Firestore save failed:", error)
                    } else {
                        print("Firestore save success")
                    }
                }
            }
        }

        private func loadIfEditing() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = db.collection("users")
                .document(uid)
                .collection("recurringDonation")
                .document("current")
            
            ref.getDocument { [weak self] snapshot, _ in
                guard let self = self,
                      let data = snapshot?.data() else { return }
                
                DispatchQueue.main.async {
                    self.finishButton.setTitle("Update", for: .normal)
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
        
        // MARK: - Alert helper
        private func showAlert(_ message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
            present(alert, animated: true)
        }
    }

