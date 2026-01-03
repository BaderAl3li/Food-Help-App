//
//  AdminDashboard.swift
//  FoodHelp
//
//  Created by BP-36-224-16 on 10/12/2025.
//

import UIKit
import FirebaseFirestore




class AdminDashboard: UIViewController {
    @IBOutlet weak var appLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appLogo = appLogo else {return}
        guard let url = URL(string: "https://res.cloudinary.com/dne7xreop/image/upload/v1766392832/app_logo1_1_jmtics.png") else {print("bad url")
            return
        }
        appLogo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
    }
}
