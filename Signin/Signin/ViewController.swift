//
//  ViewController.swift
//  Signin
//
//  Created by BP-36-224-17 on 10/12/2025.
//

import UIKit
import Cloudinary
import SDWebImage
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    

        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

}


