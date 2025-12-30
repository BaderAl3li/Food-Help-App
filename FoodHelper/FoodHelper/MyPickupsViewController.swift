//
//  MyPickupsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyPickupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , DonationCellDelegate{

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
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching pickups: \(error)")
                    return
                }

                self.items = snapshot?.documents.compactMap {
                    let data = $0.data()
                    return Donation(
                        id: $0.documentID,
                        title: data["title"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        expiryDate: (data["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                        status: data["status"] as? String ?? "",
                        latitude: data["latitude"] as? Double ?? 0,
                        longitude: data["longitude"] as? Double ?? 0,
                        acceptedBy: data["acceptedBy"] as? String
                    )
                } ?? []

                self.tableView.reloadData()
            }
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickupCell", for: indexPath) as! PickupCell
        
        let donation = items[indexPath.row]
        
        cell.configure(with: donation)
        cell.onPickTapped = { [weak self] in
                self?.markAsPicked(donationId: donation.id)
            }

        // Show title and formatted expiry date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.textLabel?.text = "\(donation.title) ⏰ \(dateFormatter.string(from: donation.expiryDate))"

        return cell
    }
    
    

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let donation = items[indexPath.row]
        db.collection("donations").document(donation.id)
            .updateData(["status": "picked"]) { error in
                if let error = error {
                    print("Error updating status: \(error)")
                } else {
                    print("Donation picked successfully")
                    self.loadPickups() // reload table
                }
            }
    }
}
