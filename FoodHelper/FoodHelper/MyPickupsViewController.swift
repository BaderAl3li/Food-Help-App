//
//  MyPickupsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyPickupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var items: [Donation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
               tableView.dataSource = self
               loadPickups()
    }

    func loadPickups() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            db.collection("donations")
                .whereField("acceptedBy", isEqualTo: uid)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments { snap, _ in
                    
                    self.items = snap?.documents.compactMap { doc in
                        let d = doc.data()
                        
                        return Donation(
                            id: doc.documentID,
                            title: d["title"] as? String ?? "",
                            description: d["description"] as? String ?? "", // Fetch description
                            expiryDate: (d["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                            status: d["status"] as? String ?? "", // Fetch the status
                            latitude: d["latitude"] as? Double ?? 0,
                            longitude: d["longitude"] as? Double ?? 0,
                            acceptedBy: d["acceptedBy"] as? String,
                            location: d["location"] as? String ?? "Unknown Location", // Fetch location
                            startTime: (d["startTime"] as? Timestamp)?.dateValue() ?? Date(), // Fetch startTime
                            endTime: (d["endTime"] as? Timestamp)?.dateValue() ?? Date() // Fetch endTime
                        )
                    } ?? []
                    self.tableView.reloadData()
                }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickupCell", for: indexPath)
            let donation = items[indexPath.row]
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            cell.textLabel?.text = "\(donation.title) ⏰ \(formatter.string(from: donation.expiryDate))"
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let donation = items[indexPath.row]
            db.collection("donations").document(donation.id).updateData(["status": "picked"]) { _ in
                self.loadPickups()
            }
        }
    }

