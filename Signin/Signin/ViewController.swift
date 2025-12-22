//
//  ViewController.swift
//  Signin
//
//  Created by BP-36-224-17 on 10/12/2025.
//

import UIKit
import Cloudinary
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    

}

