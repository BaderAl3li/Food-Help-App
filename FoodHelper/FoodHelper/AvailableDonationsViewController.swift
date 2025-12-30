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
                                        DonationCellDelegate,
                                        UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var donations: [Donation] = []
       var filteredDonations: [Donation] = []

       let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        fetchDonations()
        
    }
    
    func fetchDonations() {
        db.collection("donations")
            .whereField("status", isEqualTo: "pending")
            .getDocuments { snap, error in
                if let error = error {
                    print("Error fetching donations: \(error)")
                    return
                }

                self.donations = snap?.documents.compactMap {
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

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        self.filteredDonations = self.donations
                      self.tableView.reloadData()
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            filteredDonations.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath) as! DonationCell
        let donation = donations[indexPath.row]
        cell.configure(with: donation)
        cell.delegate = self
        return cell
    }

        // MARK: - Accept Donation
    func didTapAccept(donation: Donation) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("donations").document(donation.id)
            .updateData([
                "status": "accepted",
                "acceptedBy": uid
            ]) { error in
                if let error = error {
                    print("Error:", error)
                } else {
                    self.donations.removeAll { $0.id == donation.id }
                    self.tableView.reloadData()
                }
            }
    }

        // MARK: - Search
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredDonations = donations
            } else {
                filteredDonations = donations.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
            tableView.reloadData()
        }
    }
