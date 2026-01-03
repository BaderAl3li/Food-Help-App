import UIKit
import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseService {
    static let shared = FirebaseService()
    private var database: DatabaseReference?
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        guard FirebaseApp.app() != nil else {
            print("Firebase not configured")
            return
        }
        
        // Enable offline persistence before getting database reference
        do {
            Database.database().isPersistenceEnabled = true
        } catch {
            print("Could not enable Firebase persistence: \(error)")
        }
        
        database = Database.database(url: "https://food-9526b-default-rtdb.firebaseio.com").reference()
        
        // Keep specific paths synced
        database?.child("donations").keepSynced(true)
        database?.child("organizations").keepSynced(true)
        database?.child("notifications").child("murtadha_001").keepSynced(true)
    }
    
    func fetchUserDonations(completion: @escaping (Result<[Donation], Error>) -> Void) {
        guard let database = database else {
            print("Database not available")
            completion(.success([]))
            return
        }
        
        database.child("donations")
            .queryOrdered(byChild: "userId")
            .queryEqual(toValue: "murtadha_001")
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value) { snapshot in
                var donations: [Donation] = []
                
                guard snapshot.exists() else {
                    completion(.success([]))
                    return
                }
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let donationData = childSnapshot.value as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: donationData)
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .millisecondsSince1970
                            let donation = try decoder.decode(Donation.self, from: jsonData)
                            donations.append(donation)
                        } catch {
                            print("Error decoding donation: \(error)")
                        }
                    }
                }
                completion(.success(donations.sorted { $0.createdAt > $1.createdAt }))
            } withCancel: { error in
                print("Error fetching donations: \(error)")
                completion(.failure(error))
            }
    }
    
    func createDonation(_ donation: Donation, images: [UIImage], completion: @escaping (Result<String, Error>) -> Void) {
        guard let database = database else {
            let error = NSError(domain: "FirebaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Database not available"])
            completion(.failure(error))
            return
        }
        
        ImgBBService.shared.uploadImages(images) { [weak self] result in
            switch result {
            case .success(let imageURLs):
                var donationWithImages = donation
                donationWithImages.photos = imageURLs
                
                let donationRef = database.child("donations").childByAutoId()
                do {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .millisecondsSince1970
                    let donationData = try encoder.encode(donationWithImages)
                    let donationDict = try JSONSerialization.jsonObject(with: donationData) as? [String: Any]
                    
                    donationRef.setValue(donationDict) { error, _ in
                        if let error = error {
                            print("Error creating donation: \(error)")
                            completion(.failure(error))
                        } else {
                            print("Donation created successfully")
                            completion(.success(donationRef.key ?? ""))
                        }
                    }
                } catch {
                    print("Error encoding donation: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error uploading images: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrganizations(completion: @escaping (Result<[Organization], Error>) -> Void) {
        guard let database = database else {
            completion(.success([]))
            return
        }
        
        database.child("organizations")
            .observeSingleEvent(of: .value) { snapshot in
                var organizations: [Organization] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let orgData = childSnapshot.value as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: orgData)
                            let organization = try JSONDecoder().decode(Organization.self, from: jsonData)
                            organizations.append(organization)
                        } catch {
                        }
                    }
                }
                completion(.success(organizations))
            } withCancel: { error in
                completion(.failure(error))
            }
    }
    
    func fetchNotifications(completion: @escaping (Result<[FoodShareNotification], Error>) -> Void) {
        guard let database = database else {
            completion(.success([]))
            return
        }
        
        database.child("notifications").child("murtadha_001")
            .queryOrdered(byChild: "timestamp")
            .queryLimited(toLast: 20)
            .observeSingleEvent(of: .value) { snapshot in
                var notifications: [FoodShareNotification] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let notifData = childSnapshot.value as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: notifData)
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .millisecondsSince1970
                            let notification = try decoder.decode(FoodShareNotification.self, from: jsonData)
                            notifications.append(notification)
                        } catch {
                        }
                    }
                }
                completion(.success(notifications.sorted { $0.timestamp > $1.timestamp }))
            } withCancel: { error in
                completion(.failure(error))
            }
    }
    
    func populateTestData() {
        guard let database = database else { return }
        
        let testDataRef = database.child("testDataPopulated")
        testDataRef.observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                self.importTestDonations()
                self.importTestOrganizations()
                self.importTestNotifications()
                testDataRef.setValue(true)
            }
        }
    }
    
    private func importTestDonations() {
        guard let database = database else { return }
        
        let donations = [
            [
                "id": "donation_001",
                "userId": "murtadha_001",
                "foodName": "Fresh vegetables",
                "description": "Organic vegetables from my garden, perfect condition",
                "category": "Fresh Produce",
                "quantity": 5,
                "unit": "kg",
                "expiryDate": 1735689600000,
                "photos": [],
                "location": [
                    "latitude": 26.2285,
                    "longitude": 50.5860,
                    "address": "Building 123, Road 456",
                    "area": "Manama",
                    "instructions": "Ring doorbell"
                ],
                "status": "pending",
                "createdAt": 1703980800000,
                "isRecurring": false
            ],
            [
                "id": "donation_002",
                "userId": "murtadha_001",
                "foodName": "Cooked rice",
                "description": "Fresh cooked rice, made this morning",
                "category": "Cooked Meals",
                "quantity": 10,
                "unit": "plates",
                "expiryDate": 1704067200000,
                "photos": [],
                "location": [
                    "latitude": 26.2285,
                    "longitude": 50.5860,
                    "address": "Street 789, Riffa",
                    "area": "Riffa",
                    "instructions": "Available after 3 PM"
                ],
                "status": "accepted",
                "createdAt": 1703894400000,
                "isRecurring": true
            ],
            [
                "id": "donation_003",
                "userId": "murtadha_001",
                "foodName": "Pasta",
                "description": "Fresh pasta, homemade",
                "category": "Cooked Meals",
                "quantity": 4,
                "unit": "plates",
                "expiryDate": 1704067200000,
                "photos": [],
                "location": [
                    "latitude": 26.2285,
                    "longitude": 50.5860,
                    "address": "Avenue 555, Muharraq",
                    "area": "Muharraq",
                    "instructions": "Call before pickup"
                ],
                "status": "declined",
                "createdAt": 1703808000000,
                "isRecurring": false
            ]
        ]
        
        for donation in donations {
            if let id = donation["id"] as? String {
                database.child("donations").child(id).setValue(donation)
            }
        }
    }
    
    private func importTestOrganizations() {
        guard let database = database else { return }
        
        let organizations = [
            [
                "id": "org_001",
                "name": "Bahrain Red Crescent",
                "category": "Charity",
                "rating": 4.8,
                "address": "Building 123, Road 456, Manama",
                "phone": "+973-1234-5678",
                "email": "info@bahrainredcrescent.org",
                "description": "Dedicated to humanitarian work in Bahrain",
                "impactMetrics": [
                    "collectionsCompleted": 1250,
                    "mealsServed": 15000,
                    "peopleHelped": 3500
                ]
            ],
            [
                "id": "org_002",
                "name": "Community Care Center",
                "category": "Community",
                "rating": 4.6,
                "address": "Street 789, Block 321, Riffa",
                "phone": "+973-9876-5432",
                "email": "contact@communitycare.bh",
                "description": "Local community center providing support",
                "impactMetrics": [
                    "collectionsCompleted": 850,
                    "mealsServed": 8500,
                    "peopleHelped": 2100
                ]
            ]
        ]
        
        for org in organizations {
            if let id = org["id"] as? String {
                database.child("organizations").child(id).setValue(org)
            }
        }
    }
    
    private func importTestNotifications() {
        guard let database = database else { return }
        
        let notifications = [
            [
                "id": "notif_001",
                "userId": "murtadha_001",
                "title": "Donation Request",
                "message": "Bahrain Red Crescent has requested your 'Fresh vegetables' donation",
                "type": "donation_request",
                "donationId": "donation_001",
                "timestamp": 1704067200000,
                "isRead": false
            ],
            [
                "id": "notif_002",
                "userId": "murtadha_001",
                "title": "Pickup Scheduled",
                "message": "Pickup scheduled for tomorrow at 2 PM for your rice donation",
                "type": "pickup_scheduled",
                "donationId": "donation_002",
                "timestamp": 1703980800000,
                "isRead": true
            ],
            [
                "id": "notif_003",
                "userId": "murtadha_001",
                "title": "Donation Collected",
                "message": "Your 'Fresh Bread' donation has been collected by Bahrain Red Crescent.",
                "type": "donation_collected",
                "donationId": "donation_002",
                "timestamp": 1703894400000,
                "isRead": true
            ]
        ]
        
        for notif in notifications {
            if let id = notif["id"] as? String {
                database.child("notifications").child("murtadha_001").child(id).setValue(notif)
            }
        }
    }
}