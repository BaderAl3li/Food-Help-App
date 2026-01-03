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
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageView = imageView else {return}
        guard let url = URL(string: "https://res.cloudinary.com/dfc9jminy/image/upload/v1766385157/app_logo1_1_t4cvkh.png") else{
            print("Bad URL")
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        
    }
    
    
        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    
}


final class CurrentRecurringDonationVC: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    private var listener: ListenerRegistration?

        override func viewDidLoad() {
            super.viewDidLoad()

            infoLabel.numberOfLines = 0
            infoLabel.text = "No recurring donation yet."
            infoLabel.lineBreakMode = .byWordWrapping

            listener = try? RecurringDonationStore().listen { [weak self] data in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    guard let data = data else {
                        self.infoLabel.text = "No recurring donation yet."
                        return
                    }

                    let donationType = data["donationType"] as? String ?? "-"
                    let foodType = data["foodType"] as? String ?? "-"
                    let quantity = data["quantity"] as? Int ?? 0
                    let preferredCharity = data["preferredCharity"] as? String ?? "-"
                    let interval = data["scheduleInterval"] as? String ?? "-"
                    let time = data["scheduleTime"] as? String ?? "-"
                    let deliveryCompany = data["deliveryCompany"] as? String ?? "-"
                    let status = data["status"] as? String ?? "-"

                    self.infoLabel.text =
                    """
                    Donation Type: \(donationType)
                    Food: \(foodType) x\(quantity)
                    Charity: \(preferredCharity)
                    Schedule: \(interval) @ \(time)
                    Delivery: \(deliveryCompany)
                    Status: \(status)
                    """
                }
            }
        }

        deinit {
            listener?.remove()
        }
    }
