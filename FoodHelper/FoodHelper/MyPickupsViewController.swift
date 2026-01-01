//
//  MyPickupsViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyPickupsViewController: UIViewController,
                               UITableViewDelegate,
                               UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()

        var todayPickups: [Donation] = []
        var tomorrowPickups: [Donation] = []

    override func viewDidLoad() {
           super.viewDidLoad()

           tableView.delegate = self
           tableView.dataSource = self

           fetchPickups()
       }

       func fetchPickups() {
           guard let uid = Auth.auth().currentUser?.uid else { return }

           db.collection("users").document(uid).getDocument { snap, _ in
               guard let ngoName = snap?.data()?["org name"] as? String else { return }

               self.db.collection("donations")
                   .whereField("acceptedBy", isEqualTo: ngoName)
                   .whereField("status", isEqualTo: "accepted")
                   .getDocuments { snap, _ in

                       self.todayPickups.removeAll()
                       self.tomorrowPickups.removeAll()

                       let today = Calendar.current.startOfDay(for: Date())

                       snap?.documents.forEach { doc in
                           let d = doc.data()

                           let donation = Donation(
                               id: doc.documentID,
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
                               status: d["status"] as? String ?? "",
                               acceptedBy: d["acceptedBy"] as? String
                           )

                           let donationDay = Calendar.current.startOfDay(for: donation.expiryDate)

                           if donationDay == today {
                               self.todayPickups.append(donation)
                           } else {
                               self.tomorrowPickups.append(donation)
                           }
                       }

                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                   }
           }
       }

       // MARK: - TableView

       func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {

        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"   // 19 Nov

        let baseDate = Date()
        let date: Date

        if section == 0 {
            date = baseDate
            return "Today – \(formatter.string(from: date))"
        } else {
            date = calendar.date(byAdding: .day, value: 1, to: baseDate)!
            return "Tomorrow – \(formatter.string(from: date))"
        }
    }

       func tableView(_ tableView: UITableView,
                      numberOfRowsInSection section: Int) -> Int {
           return section == 0 ? todayPickups.count : tomorrowPickups.count
       }

       func tableView(_ tableView: UITableView,
                      cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell = tableView.dequeueReusableCell(
               withIdentifier: "PickupCell",
               for: indexPath
           ) as! PickupCell

           let donation = indexPath.section == 0
               ? todayPickups[indexPath.row]
               : tomorrowPickups[indexPath.row]

           cell.configure(with: donation)

           cell.onPickTapped = {
               self.db.collection("donations")
                   .document(donation.id)
                   .updateData(["status": "picked"])
           }

           return cell
       }
   }
