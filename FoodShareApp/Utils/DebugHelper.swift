import Foundation
import UIKit

class DebugHelper {
    static let shared = DebugHelper()
    
    private init() {}
    
    func logAppState() {
        print("=== FoodShareApp Debug Info ===")
        print("iOS Version: \(UIDevice.current.systemVersion)")
        print("Device Model: \(UIDevice.current.model)")
        print("App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "Unknown")")
        print("Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
        print("==============================")
    }
    
    func testModels() {
        print("Testing model creation...")
        
        // Test Location
        let location = Location(
            latitude: 26.2285,
            longitude: 50.5860,
            address: "Test Address",
            area: "Test Area",
            instructions: "Test Instructions"
        )
        
        // Test Donation
        let donation = Donation(
            id: "test_001",
            userId: "test_user",
            foodName: "Test Food",
            description: "Test Description",
            category: .freshProduce,
            quantity: 5,
            unit: .kg,
            expiryDate: Date(),
            photos: [],
            location: location,
            status: .pending,
            createdAt: Date(),
            isRecurring: false
        )
        
        // Test Organization
        let metrics = ImpactMetrics(
            collectionsCompleted: 100,
            mealsServed: 1000,
            peopleHelped: 500
        )
        
        let organization = Organization(
            id: "org_001",
            name: "Test Organization",
            category: .charity,
            rating: 4.5,
            address: "Test Address",
            phone: "+973-1234-5678",
            email: "test@example.com",
            description: "Test Description",
            impactMetrics: metrics,
            logoURL: nil
        )
        
        print("✅ Models created successfully")
        print("Donation: \(donation.foodName)")
        print("Organization: \(organization.name)")
    }
    
    func testFirebaseConnection() {
        print("Testing Firebase connection...")
        
        FirebaseService.shared.fetchUserDonations { result in
            switch result {
            case .success(let donations):
                print("✅ Firebase connection successful - Found \(donations.count) donations")
            case .failure(let error):
                print("❌ Firebase connection failed: \(error.localizedDescription)")
            }
        }
    }
}