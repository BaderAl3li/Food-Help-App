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
    
    private let db = Firestore.firestore()
    
    private var baseCoordinate: CLLocationCoordinate2D?
    private var trackingTimer: Timer?
    private let trackingAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityNameLabel.text = "Loading..."
        charityNameLabel.textAlignment = .center
        
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
        // 1. Get current user
        guard let uid = Auth.auth().currentUser?.uid else {
            charityNameLabel.text = "Not logged in"
            donationDetailsLabel.text = ""
            return
        }
        
        // 2. Reference to the recurring donation document
        let docRef = db.collection("users")
            .document(uid)
            .collection("recurringDonation")
            .document("current")
        
        // 3. Fetch data
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
            
            // 4. Read fields from Firestore
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
            
            // If missing, set and save the default ones ONCE
            if latitude == nil || longitude == nil {
                latitude  = 26.185218
                longitude = 50.503164
                
                var locationData: [String: Any] = [:]
                locationData["latitude"]  = latitude!
                locationData["longitude"] = longitude!
                locationData["updatedAt"] = FieldValue.serverTimestamp()
                
                docRef.setData(locationData, merge: true) { error in
                    if let error = error {
                        print("Failed to save initial coords: \(error)")
                    } else {
                        print("Initial coordinates saved to Firestore")
                    }
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            // 5. Build the text for donationDetailsLabel
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
            
            // 6. Update labels on screen
            self.charityNameLabel.text = preferredCharity
            self.donationDetailsLabel.text = detailsParts.joined(separator: "\n")
            
            // 7. Setup map & fake live tracking if we now have coordinates
            if let lat = latitude, let lon = longitude {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                self.baseCoordinate = coord
                self.setupMapTracking(at: coord)
            } else {
                print("No coordinates available even after default logic.")
            }
        }
    }
    
    private func setupMapTracking(at coordinate: CLLocationCoordinate2D) {
        // Center the map around the base coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)

        // Add / configure annotation
        trackingAnnotation.title = "Delivery Location"
        trackingAnnotation.coordinate = coordinate
        if !mapView.annotations.contains(where: { $0 === trackingAnnotation }) {
            mapView.addAnnotation(trackingAnnotation)
        }

        // Start timer for fake tracking
        startMockTracking()
    }

    private func startMockTracking() {
        trackingTimer?.invalidate() // in case it was already running

        // Update every 2 seconds (adjust as you like)
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

        let latOffset = Double.random(in: -0.005...0.005)
        let lonOffset = Double.random(in: -0.005...0.005)

        let newCoord = CLLocationCoordinate2D(
            latitude: base.latitude + latOffset,
            longitude: base.longitude + lonOffset
        )

        // Update annotation position
        trackingAnnotation.coordinate = newCoord

        // Optional: keep map centered roughly on the new location
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: newCoord, span: span)
        mapView.setRegion(region, animated: true)
    }
}
