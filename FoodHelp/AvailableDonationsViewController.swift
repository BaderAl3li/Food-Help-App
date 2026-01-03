//
//  AvailableDonationsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AvailableDonationsViewController: UIViewController,
                                        UITableViewDelegate,
                                        UITableViewDataSource,
                                        UISearchBarDelegate,
                                        DonationCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
        var donations: [Donation] = []
        var filtered: [Donation] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            tableView.rowHeight = UITableView.automaticDimension
           tableView.estimatedRowHeight = 140

            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self

            fetchDonations()
        }

        func fetchDonations() {
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snap, _ in

                    self.donations = snap?.documents.compactMap {
                        let d = $0.data()
                        return Donation(
                            id: $0.documentID,
                            title: d["title"] as? String ?? "",
                            description: d["description"] as? String ?? "",
                            quantity: d["quantity"] as? Int ?? 0,
                            itemType: d["itemType"] as? String ?? "",
                            expiryDate: (d["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                            timeOpen: d["timeOpen"] as? String ?? "",
                            timeClose: d["timeClose"] as? String ?? "",
                            donorName: d["donatBy"] as? String ?? "",
                            phoneNumber: d["PhoneNumber"] as? Int ?? 0,
                            building: d["Building"] as? Int ?? 0,
                            road: d["Road"] as? Int ?? 0,
                            latitude: d["latitude"] as? Double ?? 0,
                            longitude: d["longitude"] as? Double ?? 0,
                            status: d["status"] as? String ?? "",       // or itemStatus if you prefer
                            acceptedBy: d["acceptedBy"] as? String
                        )
                    } ?? []

                    self.filtered = self.donations
                    self.tableView.reloadData()
                }
        }

        // MARK: - TableView

    func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {
            filtered.count
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FoodCell",
                for: indexPath
            ) as! DonationCell

            let donation = filtered[indexPath.row]
            cell.configure(with: donation)
            cell.delegate = self

            return cell
        }

        // MARK: - Accept logic

        func didTapAccept(donation: Donation) {

            guard let uid = Auth.auth().currentUser?.uid else { return }

            db.collection("users").document(uid).getDocument { [weak self] snap, _ in
                guard let self = self,
                      let data = snap?.data(),
                      let ngoName = data["org name"] as? String else { return }

                self.db.collection("donations")
                    .document(donation.id)
                    .updateData([
                        "status": "accepted",
                        "acceptedBy": ngoName
                    ]) { error in
                        if error == nil {
                            self.filtered.removeAll { $0.id == donation.id }
                            self.donations.removeAll { $0.id == donation.id }
                            self.tableView.reloadData()
                        }
                    }
            }
        }

        // MARK: - Search

        func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String) {

            filtered = searchText.isEmpty
                ? donations
                : donations.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }

            tableView.reloadData()
        }
    }
