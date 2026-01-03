//
//  Donation.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import FirebaseFirestore

struct Donation {
    let id: String
    let title: String
    let description: String
    let quantity: Int
    let itemType: String
    let expiryDate: Date
    let timeOpen: String
    let timeClose: String

    let donorName: String
    let phoneNumber: Int
    let building: Int
    let road: Int

    let latitude: Double
    let longitude: Double

    let status: String
    let acceptedBy: String?
}
