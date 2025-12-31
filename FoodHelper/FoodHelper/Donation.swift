//
//  Donation.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 28/12/2025.
//

import FirebaseFirestore

import Foundation

import Foundation

struct Donation {
    let id: String
    let title: String
    let description: String
    let expiryDate: Date
    let status: String
    let latitude: Double
    let longitude: Double
    let acceptedBy: String?
    let location: String
    let startTime: Date
    let endTime: Date
}
