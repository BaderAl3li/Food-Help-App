    //
//  ViewController.swift
//  code3
//
//  Created by BP-19-114-09 on 21/12/2025.
//

import UIKit
import Cloudinary
import SDWebImage
import FirebaseFirestore

final class CurrentRecurringDonationVC: UIViewController {

    @IBOutlet weak var dailyDonationInfoLabel: UILabel!
    @IBOutlet weak var scheduleInfoLabel: UILabel!
    @IBOutlet weak var nextPickupsInfoLabel: UILabel!

    private var listener: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        listener = try? RecurringDonationStore().listen { [weak self] donation in
            guard let self = self else { return }

            guard let d = donation else {
                self.dailyDonationInfoLabel.text = "No donation yet"
                self.scheduleInfoLabel.text = "-"
                self.nextPickupsInfoLabel.text = "-"
                return
            }

            self.dailyDonationInfoLabel.text = "\(d.foodType) x\(d.quantity)"
            self.scheduleInfoLabel.text = "\(d.scheduleInterval) @ \(d.scheduleTime)"
            self.nextPickupsInfoLabel.text = "Status: \(d.status)"
        }
    }

    deinit { listener?.remove() }
}
