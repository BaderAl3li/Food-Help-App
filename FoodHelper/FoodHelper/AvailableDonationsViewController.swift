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

