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

    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var pickedLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    
    @IBOutlet weak var PendingView: UIView!
    @IBOutlet weak var PickedView: UIView!
    @IBOutlet weak var TotalView: UIView!
    @IBOutlet weak var WelcomeView: UIView!
    
    let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()

            setupUI()
            loadNGOInfo()
        }

        // MARK: - UI

        func setupUI() {
            PendingView.layer.cornerRadius = 10
            PickedView.layer.cornerRadius = 10
            TotalView.layer.cornerRadius = 10
            WelcomeView.layer.cornerRadius = 10

            WelcomeView.layer.borderWidth = 1
            WelcomeView.layer.borderColor = UIColor.purple.cgColor
        }

        // MARK: - NGO Info

        func loadNGOInfo() {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            db.collection("users").document(uid).getDocument { [weak self] snap, _ in
                guard let self = self,
                      let data = snap?.data(),
                      let ngoName = data["org name"] as? String else { return }

                DispatchQueue.main.async {
                    self.ngoNameLabel.text = ngoName

                    let approved = data["status"] as? String == "approved"
                    self.verifiedLabel.text = approved ? "Verified NGO" : "Not Verified"
                    self.verifiedLabel.textColor = approved ? .systemGreen : .systemRed
                }

                
                self.loadStats(ngoName: ngoName)
            }
        }

        // MARK: - Stats

        func loadStats(ngoName: String) {

            // Pending donations (global)
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { [weak self] snap, _ in
                    DispatchQueue.main.async {
                        self?.pendingLabel.text = "\(snap?.count ?? 0)"
                    }
                }

            // Picked by THIS NGO
            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: ngoName)
                .whereField("status", isEqualTo: "picked")
                .getDocuments { [weak self] snap, _ in
                    DispatchQueue.main.async {
                        self?.pickedLabel.text = "\(snap?.count ?? 0)"
                    }
                }

            // Total accepted by THIS NGO
            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: ngoName)
                .getDocuments { [weak self] snap, _ in
                    DispatchQueue.main.async {
                        self?.totalLabel.text = "\(snap?.count ?? 0)"
                    }
                }
        }
    }
