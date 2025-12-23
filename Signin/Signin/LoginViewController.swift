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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
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
            self?.performSegue(withIdentifier: "Home", sender: sender)
            
        }
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
