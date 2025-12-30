//
//  DonorSignUp.swift
//  Signin
//
//  Created by Guest User on 24/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Cloudinary
import SDWebImage

class DonorSignUp: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var donorName: UITextField!
    @IBOutlet weak var donorNum: UITextField!
    
    
    private let db = Firestore.firestore()
    
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
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else{
            showAlert(title: "Missing Email", message: "Please enter an email address")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else{
            showAlert(title: "Missing Password", message: "Please enter a password")
            return
        }
        guard password.count >= 6 else{
            showAlert(title: "Weak Password", message: "Please enter a password more than 6 characters")
            return
        }
        guard let userName = donorName.text, !userName.isEmpty else{
            showAlert(title: "Missing Name", message: "Please enter a name")
            return
        }
        guard let mobNum = donorNum.text, !mobNum.isEmpty else{
            showAlert(title: "Missing Number", message: "Please enter a mobile number")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] authResult, error in
            if let error = error{
                self?.showAlert(title: "Registeration Failed", message: error.localizedDescription)
                return
            }
            guard let user = authResult?.user else {
                self?.showAlert(title: "Registeration Failed", message: "Couldnt get user")
                return
            }
            
            self?.db.collection("users").document(user.uid).setData([
                "donor name": userName,
                "email" : email,
                "number": mobNum,
                "password": password,
                "role" : "donor",
                "status" : "pending"
            ])
            self?.showAlert(title: "Registeration Confirmed", message: "Please wait for 24 hours until Admin approval then open the app again and you will be inside!")
        }
    }
    
    func showAlert(title: String, message: String){
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
