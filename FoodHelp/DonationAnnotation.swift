//
//  DonationAnnotation.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 30/12/2025.
//

import MapKit

class DonationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
