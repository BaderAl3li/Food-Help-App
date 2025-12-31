//
//  AvailableDonationsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AvailableDonationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DonationCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
        let db = Firestore.firestore()
        var donations: [Donation] = []
        var filteredDonations: [Donation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
                tableView.dataSource = self
                searchBar.delegate = self
                fetchDonations()
        
    }
    
    func fetchDonations() {
        db.collection("donations").whereField("status", isEqualTo: "pending").getDocuments { snap, _ in
            guard let docs = snap?.documents else { return }
            self.donations = docs.map { doc in
                let d = doc.data()
                return Donation(
                    id: doc.documentID,
                    title: d["title"] as? String ?? "",
                    description: d["description"] as? String ?? "",
                    expiryDate: (d["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                    status: d["status"] as? String ?? "",
                    latitude: d["latitude"] as? Double ?? 0,
                    longitude: d["longitude"] as? Double ?? 0,
                    acceptedBy: d["acceptedBy"] as? String,
                    location: d["location"] as? String ?? "Unknown Location", // Ensure location is present
                    startTime: (d["startTime"] as? Timestamp)?.dateValue() ?? Date(), // Retrieve start time
                    endTime: (d["endTime"] as? Timestamp)?.dateValue() ?? Date() // Retrieve end time
                )
            }
            self.filteredDonations = self.donations
            self.tableView.reloadData()
        }
    }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredDonations.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! DonationCell
            cell.configure(with: filteredDonations[indexPath.row])
            cell.delegate = self
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DonationDetailsVC") as! DonationDetailsViewController
            vc.donation = filteredDonations[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }

        func didTapAccept(donation: Donation) {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            db.collection("donations").document(donation.id).updateData([
                "status": "accepted",
                "acceptedBy": uid
            ]) { _ in
                self.fetchDonations()
            }
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
            filteredDonations = text.isEmpty ? donations : donations.filter { $0.title.lowercased().contains(text.lowercased()) }
            tableView.reloadData()
        }
    }
