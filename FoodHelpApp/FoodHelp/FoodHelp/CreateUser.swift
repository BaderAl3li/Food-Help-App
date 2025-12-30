//
//  CreateUser.swift
//  FoodHelp
//
//  Created by BP-19-114-08 on 24/12/2025.
//

import UIKit
import Firebase
import FirebaseFirestore

class CreateUser: UIViewController {
    @IBOutlet weak var fNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createTapped(_ sender: Any) {

            let fName    = fNameField.text ?? ""
            let lName    = lNameField.text ?? ""
            let email    = emailField.text ?? ""
            let number   = numberField.text ?? ""
            let password = passwordField.text ?? ""
            let role     = roleField.text ?? ""

            // Basic validation
            if fName.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty {
                print("⚠️ Missing required fields")
                return
            }

            let userData: [String: Any] = [
                "fName": fName,
                "lName": lName,
                "email": email,
                "number": number,
                "password": password,   // ⚠️ demo only
                "role": role.lowercased(),
                "status": "approved",
                "createdAt": Timestamp()
            ]

            Firestore.firestore()
                .collection("Users")   // CAPITAL U
                .addDocument(data: userData) { error in

                    if let error = error {
                        print("❌ Failed to create user:", error)
                    } else {
                        print("✅ User created successfully")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    @IBAction func clearTapped(_ sender: Any) {
        fNameField.text = ""
        lNameField.text = ""
        emailField.text = ""
        numberField.text = ""
        roleField.text = ""
        passwordField.text = ""
    }
    

}
