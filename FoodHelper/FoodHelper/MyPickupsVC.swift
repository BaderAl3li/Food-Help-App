//
//  MyPickupsVC.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 24/12/2025.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyPickupsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pickups: [FoodDonation] = []
        let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAcceptedFood()

        // Do any additional setup after loading the view.
    }
    

    func fetchAcceptedFood() {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            db.collection("food_donations")
                .whereField("status", isEqualTo: "accepted")
                .whereField("acceptedNgoId", isEqualTo: uid)
                .getDocuments { snapshot, error in

                    if let error = error {
                        print("Firestore error:", error)
                        return
                    }

                    self.pickups.removeAll()

                    snapshot?.documents.forEach { doc in
                        let data = doc.data()

                        let item = FoodDonation(
                            id: doc.documentID,
                            title: data["title"] as? String ?? "",
                            imageUrl: data["imageUrl"] as? String ?? "",
                            pickupTime: data["pickupTime"] as? String ?? "",
                            pickupDate: data["pickupDate"] as? String ?? "",
                            location: data["locationName"] as? String ?? "",
                            distance: data["distanceKm"] as? Double ?? 0,
                            status: data["status"] as? String ?? ""
                        )

                        self.pickups.append(item)
                    }

                    self.tableView.reloadData()
                }
        }
    }

extension MyPickupsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickups.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PickupCell",
            for: indexPath
        ) as! PickupCell

        cell.configure(pickups[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected:", pickups[indexPath.row].title)
    }
}
