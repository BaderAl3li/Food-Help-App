//
//  Leaderboard.swift
//  Signin
//
//  Created by BP-19-131-02 on 29/12/2025.
//

import UIKit
import FirebaseFirestore

struct LeaderboardRow{
    let username: String
    let totalQuantity: Int
}

class Leaderboard: UIViewController, UITableViewDataSource {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    private var lb: [LeaderboardRow] = []
    private var listener: ListenerRegistration?
    
    private func startListening() {
        listener = Firestore.firestore()
            .collection("users").order(by: "totalQuantity", descending: true).limit(to: 10).addSnapshotListener { [weak self] snapshot, _ in
                guard let self = self else {return}

                self.lb = (snapshot?.documents ?? []).map { doc in let data = doc.data()
                    return LeaderboardRow(username: data["donor name"] as? String ?? "Unknown", totalQuantity: data["totalQuantity"] as? Int ?? 0)
                }
                self.tableView.reloadData()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        lb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath)
        
        let row = lb[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(row.username)"
        cell.detailTextLabel?.text = "Total Donations: \(row.totalQuantity)"
        
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.detailTextLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        cell.detailTextLabel?.textColor = .secondaryLabel

            
        cell.backgroundColor = .secondarySystemGroupedBackground
        cell.contentView.backgroundColor = .secondarySystemGroupedBackground
        cell.layer.masksToBounds = true
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.separator.cgColor
        cell.layer.masksToBounds = true


        cell.selectionStyle = .none
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        startListening()
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
