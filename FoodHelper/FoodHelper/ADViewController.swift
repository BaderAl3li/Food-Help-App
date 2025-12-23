//
//  ADViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 15/12/2025.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ADViewController: UIViewController {
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()

      var foodList: [FoodItem] = [] // All Firebase data
      var filteredList: [FoodItem] = [] // Search result
      var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
                tableView.dataSource = self

                searchBar.delegate = self
                searchBar.placeholder = "Available Donations..."
                searchBar.showsCancelButton = true

                tableView.keyboardDismissMode = .onDrag

                fetchDataFromFirebase()
            }

            // 🔥 FETCH FIREBASE DATA
    func fetchDataFromFirebase() {

        db.collection("donations")
            .whereField("state", isEqualTo: "pending")
            .addSnapshotListener { snapshot, error in

            if let error = error {
                print("Firebase error:", error)
                return
            }

            self.foodList.removeAll()

            snapshot?.documents.forEach { doc in
                let data = doc.data()

                let item = FoodItem(
                    name: data["name"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? "",
                    plates: data["plates"] as? Int ?? 0,
                    expires: data["expires"] as? String ?? "",
                    distance: data["distance"] as? String ?? "",
                    market: data["market"] as? String ?? ""
                )

                self.foodList.append(item)
            }

            self.filteredList = self.foodList
            self.tableView.reloadData()
        }
    }
    
    // 🔥 ACCEPT PICKUP
        func acceptDonation(item: FoodItem) {

            guard let ngoId = Auth.auth().currentUser?.uid else {
                print("NGO not logged in")
                return
            }

            db.collection("donations").document(item.id).updateData([
                "state": "accepted",
                "acceptedBy": ngoId,
                "acceptedAt": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Accept error:", error)
                } else {
                    print("Donation accepted")
                }
            }
        }

            // 🖼 IMAGE LOADER
            func loadImage(url: String, imageView: UIImageView) {
                guard let imageURL = URL(string: url) else { return }

                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }





extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredList.count : foodList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell",
                                                 for: indexPath) as! FoodCell

        let item = isSearching
        ? filteredList[indexPath.row]
        : foodList[indexPath.row]

        cell.nameLabel.text = item.name
        cell.infoLabel.text = "\(item.plates) Plates · Expires \(item.expires)"
        cell.locationLabel.text = "\(item.distance) · \(item.market)"

        loadImage(url: item.imageUrl, imageView: cell.foodImage)
        
        cell.acceptAction = { [weak self] in
            self?.acceptDonation(item: item)
        }

        return cell
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            isSearching = false
            filteredList = foodList
        } else {
            isSearching = true
            filteredList = foodList.filter { item in
                item.name.lowercased().contains(searchText.lowercased()) ||
                item.market.lowercased().contains(searchText.lowercased())
            }
        }

        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredList = foodList
        tableView.reloadData()
    }
}
