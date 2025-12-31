//
//  CallVc.swift
//  code3
//
//  Created by BP-19-131-02 on 30/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CallVc: UIViewController {

    @IBOutlet weak var charityLabel: UILabel!
    
    private let db = Firestore.firestore()
    
    // FIXED number
    private let fixedNumber = "+97312345678"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityLabel.textAlignment = .center
        charityLabel.text = "Delivering to (…)"
        
        
        loadCharity()
    }
    
    private func loadCharity() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("users")
            .document(uid)
            .collection("recurringDonation")
            .document("current")
        
        ref.getDocument { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let data = snapshot?.data(), !data.isEmpty else { return }
            
            let charityName = data["preferredCharity"] as? String ?? "Unknown"
            self.charityLabel.text = "Delivering to (\(charityName))"
        }
    }
    
    @IBAction func copyNumberTapped(_ sender: UIButton) {
        UIPasteboard.general.string = fixedNumber
    }
}
