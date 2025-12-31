//
//  DashboardViewController.swift
//  Food Help
//
//  Created by Hamood Hammad on 12/29/25.
//

import UIKit

class DashboardViewController: UIViewController {

    // Connect this IBOutlet to your UIView (the card)
    @IBOutlet weak var MainCard: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do NOT set corner radius here
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        applyTopCornerRadius()
    }

    private func applyTopCornerRadius() {
        MainCard.layer.cornerRadius = 16
        MainCard.layer.maskedCorners = [
            .layerMinXMinYCorner, // top-left
            .layerMaxXMinYCorner  // top-right
        ]
        MainCard.clipsToBounds = true
    }
}

