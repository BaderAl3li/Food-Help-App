//
//  DonorAccountInfor.swift
//  FoodHelp
//
//  Created by BP-36-213-01                                                         on 03/01/2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DonorAccountInfor: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var donorEmail: UILabel!
    @IBOutlet weak var donorNum: UILabel!
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }

            Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument { snap, error in

                    if let error = error {
                        print("Error")
                        return
                    }

                    guard let data = snap?.data() else {
                        print("Error")
                        return
                    }

                    DispatchQueue.main.async {
                        self.userName.text = data["donor name"] as? String ?? "-"
                        self.donorEmail.text = data["email"] as? String ?? "-"
                        self.donorNum?.text = data["number"] as? String ?? "-"
                    }
                }

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
