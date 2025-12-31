//
//  RecurringFirstVc.swift
//  code3
//
//  Created by BP-36-201-24 on 29/12/2025.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class TrackingFirstVc: UIViewController {
    
    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var donationDetailsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var charityName: UILabel!
    
    private let db = Firestore.firestore()
    
    private var baseCoordinate: CLLocationCoordinate2D?
    private var trackingTimer: Timer?
    private let trackingAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityNameLabel.text = "Loading..."
        charityNameLabel.textAlignment = .center
        charityName.textAlignment = .center
        
        donationDetailsLabel.numberOfLines = 0
        donationDetailsLabel.lineBreakMode = .byWordWrapping
        donationDetailsLabel.textAlignment = .center
        donationDetailsLabel.text = ""
        
        let defaultCenter = CLLocationCoordinate2D(latitude: 26.0667, longitude: 50.5577)
        let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let defaultRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
        mapView.setRegion(defaultRegion, animated: false)
        
        loadRecurringDonation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        trackingTimer?.invalidate()
    }
    
    private func loadRecurringDonation() {
        guard let uid = Auth.auth().currentUser?.uid else {
            charityNameLabel.text = "Not logged in"
            donationDetailsLabel.text = ""
            return
        }
        
        let docRef = db.collection("users")
            .document(uid)
            .collection("recurringDonation")
            .document("current")
        
        docRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.charityNameLabel.text = "Error"
                self.donationDetailsLabel.text = error.localizedDescription
                return
            }
            
            guard let data = snapshot?.data(), !data.isEmpty else {
                self.charityNameLabel.text = "NA"
                self.donationDetailsLabel.text = "You don't have an active recurring donation."
                return
            }
            
            let preferredCharity = data["preferredCharity"] as? String ?? "Unknown charity"
            let donationType = data["donationType"] as? String ?? "-"
            let deliveryCompany = data["deliveryCompany"] as? String ?? "-"
            let status = data["status"] as? String ?? "-"
            
            let quantity = data["quantity"] as? Int
            let schedule = data["schedule"] as? String
            
            let startTimestamp = data["startDate"] as? Timestamp
            let endTimestamp = data["endDate"] as? Timestamp
            
            let startDate = startTimestamp?.dateValue()
            let endDate = endTimestamp?.dateValue()
            
            var latitude  = data["latitude"]  as? Double
            var longitude = data["longitude"] as? Double
            
            if latitude == nil || longitude == nil {
                latitude  = 26.185218
                longitude = 50.503164
                
                var locationData: [String: Any] = [:]
                locationData["latitude"]  = latitude!
                locationData["longitude"] = longitude!
                locationData["updatedAt"] = FieldValue.serverTimestamp()
                
                docRef.setData(locationData, merge: true) { _ in }
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            var detailsParts: [String] = []
            
            detailsParts.append("Type: \(donationType)")
            detailsParts.append("Delivery: \(deliveryCompany)")
            
            if let quantity = quantity {
                detailsParts.append("Quantity: \(quantity)")
            }
            
            if let startDate = startDate {
                detailsParts.append("From: \(formatter.string(from: startDate))")
            }
            if let endDate = endDate {
                detailsParts.append("To: \(formatter.string(from: endDate))")
            }
            
            if let schedule = schedule, !schedule.isEmpty {
                detailsParts.append("Schedule: \(schedule)")
            }
            
            detailsParts.append("Status: \(status)")
            
            self.charityNameLabel.text = preferredCharity
            self.donationDetailsLabel.text = detailsParts.joined(separator: "\n")
            
            if let lat = latitude, let lon = longitude {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                self.baseCoordinate = coord
                self.setupMapTracking(at: coord)
            }
        }
    }
    
    private func setupMapTracking(at coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        trackingAnnotation.title = "REHAN"
        trackingAnnotation.coordinate = coordinate
        
        if !mapView.annotations.contains(where: { $0 === trackingAnnotation }) {
            mapView.addAnnotation(trackingAnnotation)
        }

        startMockTracking()
    }

    private func startMockTracking() {
        trackingTimer?.invalidate()

        trackingTimer = Timer.scheduledTimer(
            timeInterval: 1.5,
            target: self,
            selector: #selector(updateMockLocation),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateMockLocation() {
        guard let base = baseCoordinate else { return }

        let latOffset = Double.random(in: -0.0025...0.0025)
        let lonOffset = Double.random(in: -0.0025...0.0025)

        let newCoord = CLLocationCoordinate2D(
            latitude: base.latitude + latOffset,
            longitude: base.longitude + lonOffset
        )

        trackingAnnotation.coordinate = newCoord
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: newCoord, span: span)
        mapView.setRegion(region, animated: true)
    }
}
