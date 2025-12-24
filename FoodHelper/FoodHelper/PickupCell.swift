//
//  PickupCell.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 24/12/2025.
//

import UIKit

class PickupCell: UITableViewCell {
    
    @IBOutlet weak var foodImage: UIImageView!
      @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var timeLabel: UILabel!
      @IBOutlet weak var locationLabel: UILabel!
      @IBOutlet weak var statusLabel: UILabel!

    func configure(_ food: FoodDonation) {
           titleLabel.text = food.title
           timeLabel.text = food.pickupTime
           locationLabel.text = "\(food.location)"
           statusLabel.text = "Status: \(food.status.capitalized)"

           if let url = URL(string: food.imageUrl) {
               DispatchQueue.global().async {
                   let data = try? Data(contentsOf: url)
                   DispatchQueue.main.async {
                       self.foodImage.image = UIImage(data: data ?? Data())
                   }
               }
           }
       }
   }
