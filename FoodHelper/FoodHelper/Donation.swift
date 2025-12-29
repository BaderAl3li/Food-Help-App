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
    let expiryDate: Date
    let status: String
    let latitude: Double
    let longitude: Double
    let acceptedBy: String?

    // Designated initializer
    init(id: String, title: String, description: String, expiryDate: Date,
         status: String, latitude: Double, longitude: Double, acceptedBy: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.expiryDate = expiryDate
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.acceptedBy = acceptedBy
    }
}
