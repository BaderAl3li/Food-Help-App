//
//  DonationCell.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 29/12/2025.
//

import UIKit

protocol DonationCellDelegate: AnyObject {
    func didTapAccept(donation: Donation)
}

class DonationCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    weak var delegate: DonationCellDelegate?
        private var donation: Donation!
    
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
            self.donation = donation
            titleLabel.text = donation.title
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            expiryLabel.text = "⏰ Expires: \(formatter.string(from: donation.expiryDate))"
        }
    
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        delegate?.didTapAccept(donation: donation)
            }
    }
