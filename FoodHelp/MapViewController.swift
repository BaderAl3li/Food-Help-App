//
//  MapViewController.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 30/12/2025.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let db = Firestore.firestore()

       override func viewDidLoad() {
           super.viewDidLoad()
           mapView.delegate = self
           fetchNGOAndLoadDonations()
           styleMap()
       }
    
    func styleMap() {
            mapView.layer.cornerRadius = 16
            mapView.clipsToBounds = true

            mapView.layer.borderWidth = 1
            mapView.layer.borderColor = UIColor.purple.cgColor

            // Optional shadow (wrap mapView in a UIView if shadow is clipped)
            mapView.layer.shadowColor = UIColor.black.cgColor
            mapView.layer.shadowOpacity = 0.15
            mapView.layer.shadowOffset = CGSize(width: 0, height: 4)
            mapView.layer.shadowRadius = 6
        }

       // MARK: - Fetch NGO Name First

       func fetchNGOAndLoadDonations() {
           guard let uid = Auth.auth().currentUser?.uid else { return }

           db.collection("users").document(uid).getDocument { [weak self] snap, _ in
               guard let self = self,
                     let data = snap?.data(),
                     let ngoName = data["org name"] as? String else { return }

               self.loadAcceptedDonations(ngoName: ngoName)
           }
       }

       // MARK: - Load Accepted Donations

       func loadAcceptedDonations(ngoName: String) {

           mapView.removeAnnotations(mapView.annotations)

           db.collection("donations")
               .whereField("status", isEqualTo: "accepted")
               .whereField("acceptedBy", isEqualTo: ngoName)
               .getDocuments { [weak self] snap, _ in

                   guard let self = self,
                         let docs = snap?.documents else { return }

                   for doc in docs {
                       let d = doc.data()

                       let lat = d["latitude"] as? Double ?? 0
                       let lng = d["longitude"] as? Double ?? 0
                       guard lat != 0 && lng != 0 else { continue }

                       let pin = MKPointAnnotation()
                       pin.title = d["title"] as? String ?? "Donation"
                       pin.subtitle = d["donatBy"] as? String ?? "Donor"
                       pin.coordinate = CLLocationCoordinate2D(
                           latitude: lat,
                           longitude: lng
                       )

                       DispatchQueue.main.async {
                           self.mapView.addAnnotation(pin)
                       }
                   }

                   // Optional: zoom to pins
                   self.zoomToAnnotations()
               }
       }

       // MARK: - Zoom Helper

       func zoomToAnnotations() {
           let annotations = mapView.annotations
           guard !annotations.isEmpty else { return }
           mapView.showAnnotations(annotations, animated: true)
       }
   }
