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
            db.collection("donations")
                .whereField("status", isEqualTo: "pending")
                .getDocuments { snapshot, _ in

                    guard let docs = snapshot?.documents else { return }

                    for doc in docs {
                        let data = doc.data()
                        guard
                            let lat = data["latitude"] as? Double,
                            let lng = data["longitude"] as? Double,
                            let name = data["donorName"] as? String,
                            let road = data["road"] as? String
                        else { continue }

                        let annotation = DonationAnnotation(
                            title: name,
                            subtitle: road,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        )

                        self.mapView.addAnnotation(annotation)
                    }
                }
        }

        // MARK: - Custom View
        func mapView(_ mapView: MKMapView,
                     viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            if annotation is MKUserLocation { return nil }

            let identifier = DonationPinView.identifier
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? DonationPinView

            if view == nil {
                view = DonationPinView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = annotation
            }

            return view
        }
    }
