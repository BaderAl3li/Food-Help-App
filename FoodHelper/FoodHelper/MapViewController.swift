//
//  MapViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 30/12/2025.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
        let db = Firestore.firestore()

        override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self
            loadDonations()
        }

    func loadDonations() {
            db.collection("donations").whereField("status", isEqualTo: "pending").getDocuments { snap, _ in
                guard let docs = snap?.documents else { return }

                for doc in docs {
                    let d = doc.data()
                    let lat = d["latitude"] as? Double ?? 0
                    let lng = d["longitude"] as? Double ?? 0
                    let pin = MKPointAnnotation()
                    pin.title = d["title"] as? String
                    pin.subtitle = d["description"] as? String
                    pin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    self.mapView.addAnnotation(pin)
                }
            }
        }
    }
