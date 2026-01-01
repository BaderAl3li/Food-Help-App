//
//  PickupCell.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 31/12/2025.
//

import UIKit

class PickupCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickupButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var donorLabel: UILabel!
    
    @IBOutlet weak var PickupView: UIView!
    var onPickTapped: (() -> Void)?

        override func awakeFromNib() {
            super.awakeFromNib()
            foodImageView.layer.cornerRadius = 10
           
            PickupView.layer.cornerRadius = 10
            PickupView.layer.borderWidth = 1
            PickupView.layer.borderColor = UIColor.purple.cgColor
            
            
        }

        func configure(with donation: Donation) {
            titleLabel.text = donation.title
            timeLabel.text = "\(donation.timeOpen) - \(donation.timeClose)"
            donorLabel.text = donation.donorName
        }

        @IBAction func pickTapped(_ sender: UIButton) {
            onPickTapped?()
        }
    }
