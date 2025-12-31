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
    @IBOutlet weak var locationLabel: UILabel!
    
    var onPickTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        foodImageView.layer.cornerRadius = 10
        foodImageView.clipsToBounds = true
        
        pickupButton.layer.cornerRadius = 8
        pickupButton.setTitle("Pickup Complete", for: .normal)
        pickupButton.backgroundColor = UIColor.systemBlue
        pickupButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func pickButtonTapped(_ sender: UIButton) {
        onPickTapped?()
        
        func configure(with donation: Donation) {
            titleLabel.text = donation.title
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm" // Set format to 24-hour
            let startTimeString = formatter.string(from: donation.startTime)
            let endTimeString = formatter.string(from: donation.endTime)
            locationLabel.text = "Location: \(donation.location)" // Set location
            timeLabel.text = "Available: from \(startTimeString) to \(endTimeString)" // Display time range
            
            foodImageView.image = UIImage(named: "food_placeholder") // Placeholder image
        }

    }
}
