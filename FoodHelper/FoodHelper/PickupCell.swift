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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickupButton: UIButton!
    
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
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            detailLabel.text = "Expires: \(formatter.string(from: donation.expiryDate))"
            statusLabel.text = "Status: \(donation.status.capitalized)"
            
            foodImageView.image = UIImage(named: "food_placeholder") // optional
        }
    }
}
