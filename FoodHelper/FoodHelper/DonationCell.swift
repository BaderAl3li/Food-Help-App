//
//  DonationCell.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 29/12/2025.
//

import UIKit

class DonationCell: UITableViewCell {
    
        @IBOutlet weak var cardView: UIView!
        @IBOutlet weak var foodImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var expiryLabel: UILabel!
        @IBOutlet weak var distanceLabel: UILabel!
        @IBOutlet weak var acceptButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI() {
            cardView.layer.cornerRadius = 14
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
            cardView.layer.shadowRadius = 6

            foodImageView.layer.cornerRadius = 8
            foodImageView.clipsToBounds = true

            acceptButton.layer.cornerRadius = 8
        }

    func configure(with donation: Donation) {
        titleLabel.text = donation.title

        if let expiry = donation.expiryDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            expiryLabel.text = "⏰ Expires: \(dateFormatter.string(from: expiry.dateValue()))"
            expiryLabel.isHidden = false
        } else {
            expiryLabel.isHidden = true
        }

        distanceLabel.text = donation.distance != nil
            ? "📍 \(donation.distance!) km"
            : ""

        foodImageView.image = UIImage(named: donation.imageName ?? "food_placeholder")
    }
    }
