//
//  NGOprofile.swift
//  Signin
//
//  Created by BP-19-131-02 on 29/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NGOprofile: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ngoEmail: UILabel!
    @IBOutlet weak var ngoNum: UILabel!
    
    override func viewDidLoad() {
        loadUserData()
        super.viewDidLoad()

    }
    
    
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
                        self.userName.text = data["org name"] as? String ?? "-"
                        self.ngoEmail.text = data["email"] as? String ?? "-"
                        self.ngoNum?.text = data["number"] as? String ?? "-"
                    }
                }

    }
    
    @IBAction func signoutClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Logging out requires to log in again. Are you sure you want to continue?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(
            UIAlertAction(title: "Sign out", style: .destructive) { _ in
                do {
                    try Auth.auth().signOut()
                    self.navigateToLogin()
                } catch {
                    self.showAlert(title: "Signout Failed", message: "Retry in a few minutes")
                }
            }
        )

        present(alert, animated: true)

    }
    
    func navigateToLogin(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewController(withIdentifier: "Home")

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
