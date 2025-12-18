//
//  AD2ViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 15/12/2025.
//

import UIKit

class AD2ViewController: UIViewController {
    
    @IBOutlet weak var Information: UIView!
    @IBOutlet weak var Detail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Detail.layer.cornerRadius=20
        Detail.layer.borderColor=UIColor.purple.cgColor
        Detail.layer.borderWidth=1
        Detail.layer.shadowColor=UIColor.purple.cgColor
        Detail.layer.shadowOpacity=0.12
        Detail.layer.shadowOffset=CGSize(width: 0, height: 4)
        Detail.layer.shadowRadius=10
        
        Information.layer.cornerRadius=20
        Information.layer.borderColor=UIColor.purple.cgColor
        Information.layer.borderWidth=1
        Information.layer.shadowColor=UIColor.purple.cgColor
        Information.layer.shadowOpacity=0.12
        Information.layer.shadowOffset=CGSize(width: 0, height: 4)
        Information.layer.shadowRadius=10
        
        
    }
}
