    //
//  ViewController.swift
//  code3
//
//  Created by BP-19-114-09 on 21/12/2025.
//

import UIKit
import Cloudinary
import SDWebImage


class ViewController: UIViewController {

    @IBOutlet weak var call_logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let call_logo = call_logo else {return}
        guard let url = URL (string: "https://res.cloudinary.com/daeudw63f/image/upload/v1766392780/image_10_jzg2fr.png")
        else {print("bad url")
            return
        }
        call_logo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
                                    // Do any additional setup after loading the view.
    }


}

