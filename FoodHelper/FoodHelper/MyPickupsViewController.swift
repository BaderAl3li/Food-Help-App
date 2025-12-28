//
//  MyPickupsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyPickupsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
        let db = Firestore.firestore()
        var items: [Donation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPickups()
       
    }
    func loadPickups() {
            let uid = Auth.auth().currentUser!.uid

            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: uid)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments { snap, _ in
                    self.items = snap?.documents.compactMap {
                        Donation(
                            id: $0.documentID,
                            title: $0["title"] as? String ?? "",
                            description: "",
                            expiryDate: ($0["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                            status: $0["status"] as? String ?? "",
                            latitude: 0,
                            longitude: 0,
                            acceptedBy: $0["acceptedBy"] as? String
                        )
                    } ?? []
                    self.tableView.reloadData()
                }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickupCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row].title
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let id = items[indexPath.row].id
            db.collection("donations").document(id)
                .updateData(["status": "picked"])
        }
    }
