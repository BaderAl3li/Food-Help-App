    //
//  ViewController.swift
//  code3
//
//  Created by BP-19-114-09 on 21/12/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class CurrentRecurringDonationVC: UIViewController {

    // Connect this to ONE UILabel in your storyboard (e.g. a big multiline label)
    @IBOutlet weak var infoLabel: UILabel!
    private var listener: ListenerRegistration?

        override func viewDidLoad() {
            super.viewDidLoad()

            infoLabel.numberOfLines = 0
            infoLabel.text = "Loading..."
            infoLabel.lineBreakMode = .byWordWrapping

            listener = try? RecurringDonationStore().listen { [weak self] data in
                guard let self = self else { return }

                // Always update UI on main thread
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
