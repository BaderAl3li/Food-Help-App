//
//  AvailableDonationsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AvailableDonationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
        var donations: [Donation] = []
        let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchDonations()
        
    }
    
    func fetchDonations() {
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snap, _ in
                    self.donations = snap?.documents.compactMap {
                        Donation(
                            id: $0.documentID,
                            title: $0["title"] as? String ?? "",
                            description: $0["description"] as? String ?? "",
                            expiryDate: ($0["expiryDate"] as? Timestamp)?.dateValue() ?? Date(),
                            status: $0["status"] as? String ?? "",
                            latitude: $0["latitude"] as? Double ?? 0,
                            longitude: $0["longitude"] as? Double ?? 0,
                            acceptedBy: $0["acceptedBy"] as? String
                        )
                    } ?? []
                    self.tableView.reloadData()
                }
        }
    
    

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            donations.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DonationCell", for: indexPath)
            let item = donations[indexPath.row]
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "Expires: \(item.expiryDate)"
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DonationDetailsVC") as! DonationDetailsViewController
            vc.donation = donations[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

