//
//  NgoApprovalView.swift
//  FoodHelp
//
//  Created by BP-19-114-08 on 24/12/2025.
//

import UIKit
import FirebaseFirestore
import Firebase

class NgoApprovalView: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var currentNgoId: String?
    override func viewDidLoad() {
          super.viewDidLoad()
          loadPendingNgo()
      }

      // MARK: - Firestore
      func loadPendingNgo() {
          Firestore.firestore()
              .collection("ngoRequests")
              .whereField("status", isEqualTo: "pending")
              .limit(to: 1)
              .getDocuments { snapshot, error in

                  if let error = error {
                      print("❌ Firestore error:", error)
                      return
                  }

                  guard let doc = snapshot?.documents.first else {
                      print("ℹ️ No pending NGOs")
                      self.showNoRequestsState()
                      return
                  }

                  let data = doc.data()
                  self.currentNgoId = doc.documentID

                  print("✅ Loaded NGO:", data)

                  self.nameLabel.text  = data["name"] as? String ?? "-"
                  self.emailLabel.text = data["email"] as? String ?? "-"
                  self.phoneLabel.text = data["phone"] as? String ?? "-"
              }
      }

      // MARK: - UI States
      func showNoRequestsState() {
          nameLabel.text = "No pending NGOs"
          emailLabel.text = ""
          phoneLabel.text = ""
      }

      // MARK: - Actions
      
    @IBAction func approveTapped(_ sender: Any) {
        updateStatus("approved")
    }
    @IBAction func declineTapped(_ sender: Any) {
        updateStatus("decline")
    }
    
      func updateStatus(_ status: String) {
          guard let ngoId = currentNgoId else {
              print("⚠️ No NGO selected")
              return
          }

          Firestore.firestore()
              .collection("ngoRequests")
              .document(ngoId)
              .updateData(["status": status]) { error in
                  if let error = error {
                      print("❌ Update failed:", error)
                  } else {
                      print("✅ NGO status updated to:", status)
                      self.loadPendingNgo()
                  }
              }
      }


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


