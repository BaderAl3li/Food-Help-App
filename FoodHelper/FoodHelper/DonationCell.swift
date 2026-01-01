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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var donorLabel: UILabel!
    
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
        
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.purple.cgColor
        
    }
    
    func configure(with donation: Donation) {
        titleLabel.text = donation.title

        let formatter = DateFormatter()
        formatter.dateStyle = .medium   // e.g. Feb 6, 2026
        formatter.timeStyle = .none

        let expiryText = formatter.string(from: donation.expiryDate)

        detailLabel.text = "\(donation.quantity) Plates • Expires \(expiryText)"
        donorLabel.text = donation.donorName
    }
    
    }
