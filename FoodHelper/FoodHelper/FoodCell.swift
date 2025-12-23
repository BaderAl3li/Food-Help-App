//
//  FoodCell.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 18/12/2025.
//

import UIKit

class FoodCell: UITableViewCell {

    @IBOutlet weak var Card: UIView!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodInfo: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    var acceptAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        FoodImage.layer.cornerRadius = 8
        
        Card.layer.cornerRadius = 12
        Card.layer.shadowColor = UIColor.black.cgColor
        Card.layer.shadowOffset = CGSize(width: 0, height: 2)
        Card.layer.shadowOpacity = 0.1
        Card.layer.shadowRadius = 6
        
    }

    @IBAction func acceptTapped(_ sender: UIButton) {
        acceptAction?()
    }
}
}
