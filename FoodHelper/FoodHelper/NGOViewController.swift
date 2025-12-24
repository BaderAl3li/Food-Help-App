//
//  NGOViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 14/12/2025.
//

import UIKit

class NGOHomeViewController: UIViewController {

    
    @IBOutlet weak var Buttom: UIButton!
    @IBOutlet weak var Nearby: UIView!
    @IBOutlet weak var PandingCard: UIView!
    @IBOutlet weak var WelcomeCard: UIView!
    @IBOutlet weak var TotalCard: UIView!
    @IBOutlet weak var PickedCard: UIView!
    @IBOutlet weak var UrgentCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        WelcomeCard.layer.cornerRadius=20
        WelcomeCard.layer.borderColor=UIColor.purple.cgColor
        WelcomeCard.layer.borderWidth=1
        WelcomeCard.layer.shadowColor=UIColor.purple.cgColor
        WelcomeCard.layer.shadowOpacity=0.12
        WelcomeCard.layer.shadowOffset=CGSize(width: 0, height: 4)
        WelcomeCard.layer.shadowRadius=10
        
        TotalCard.layer.cornerRadius=13
        PandingCard.layer.cornerRadius=13
        PickedCard.layer.cornerRadius=13
        
        UrgentCard.layer.cornerRadius=20
        UrgentCard.layer.borderColor=UIColor.purple.cgColor
        UrgentCard.layer.borderWidth=1
        UrgentCard.layer.shadowColor=UIColor.purple.cgColor
        UrgentCard.layer.shadowOpacity=0.12
        UrgentCard.layer.shadowOffset=CGSize(width: 0, height: 4)
        UrgentCard.layer.shadowRadius=1
       
        
        Nearby.layer.cornerRadius=20
        Nearby.layer.borderColor=UIColor.purple.cgColor
        Nearby.layer.borderWidth=1
        Nearby.layer.shadowColor=UIColor.purple.cgColor
        Nearby.layer.shadowOpacity=0.12
        Nearby.layer.shadowOffset=CGSize(width: 0, height: 4)
        Nearby.layer.shadowRadius=10
        
        
        Buttom.layer.cornerRadius=10
    }
    



}
