//
//  LoginViewController.swift
//  Signin
//
//  Created by Guest User on 23/12/2025.
//

import UIKit
import FirebaseAuth
import Cloudinary
import SDWebImage
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let db = Firestore.firestore()
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else{
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else{
            showAlert(title: "Missing Password", message: "Please enter your password")
            return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password){
            [weak self] authResult, error in
            if let error = error {
                self?.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            guard let uid = authResult?.user.uid else{
                self?.showAlert(title: "Login Failed", message: "User does not exits")
                return
            }
            
            self?.db.collection("users").document(uid).getDocument{[weak self] snap, error in
                guard let self = self else {return}
                if let error = error{
                    self.showAlert(title: "Error", message: "Could not load role")
                    return
                }
                guard let data = snap?.data(),
                      let role = (data["role"] as? String)?.lowercased() else{
                    self.showAlert(title: "Missing Alert", message: "This account has no role")
                    return
                }
                switch role{
                case "donor":
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    Firestore.firestore().collection("users").document(uid).getDocument{ [weak self] snapshot, _ in
                        guard let self = self else {return}
                        
                        let status = snapshot?.data()?["status"] as? String ?? "pending"
                        
                        if status == "approved"{
                            self.performSegue(withIdentifier: "Home", sender: sender)
                        }else if status == "pending"{
                            self.showAlert(title: "Please Wait", message: "Please Wait 24 Hours Until Admin Approval")
                        }else{
                            self.showAlert(title: "Account Rejected", message: "Please register again as your account has been rejected.")
                        }
                    }
                    
                case "ngo":
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    Firestore.firestore().collection("users").document(uid).getDocument{ [weak self] snapshot, _ in
                        guard let self = self else {return}
                        
                        let status = snapshot?.data()?["status"] as? String ?? "pending"
                        
                        if status == "approved"{
                            self.performSegue(withIdentifier: "NgoHome", sender: sender)
                        }else if status == "pending"{
                            self.showAlert(title: "Please Wait", message: "Please Wait 24 Hours Until Admin Approval")
                        }else{
                            self.showAlert(title: "Account Rejected", message: "Please register again as your account has been rejected.")
                        }
                    }
                
                case "admin":
                    self.performSegue(withIdentifier: "AdminHome", sender: sender)
                
                default:
                    self.showAlert(title: "Unknown Role", message: "Role does not exist")
                }
            }
            
            
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let imageView = imageView else {return}
        guard let url = URL(string: "https://res.cloudinary.com/dfc9jminy/image/upload/v1766385157/app_logo1_1_t4cvkh.png") else{
            print("Bad URL")
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
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
