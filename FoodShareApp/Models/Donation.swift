import Foundation

struct Donation: Codable {
    let id: String
    let userId: String
    let foodName: String
    let description: String
    let category: FoodCategory
    let quantity: Int
    let unit: QuantityUnit
    let expiryDate: Date
    var photos: [String]
    let location: Location
    let status: DonationStatus
    let createdAt: Date
    let isRecurring: Bool
    
    enum FoodCategory: String, CaseIterable, Codable {
        case freshProduce = "Fresh Produce"
        case cookedMeals = "Cooked Meals"
        case bakery = "Bakery"
        case cannedPackaged = "Canned/Packaged"
        case other = "Other"
    }
    
    enum QuantityUnit: String, CaseIterable, Codable {
        case kg = "kg"
        case plates = "plates"
        case pieces = "pieces"
        case liters = "liters"
        case packs = "packs"
    }
    
    enum DonationStatus: String, Codable {
        case pending = "pending"
        case accepted = "accepted"
        case declined = "declined"
        case collected = "collected"
    }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
    let area: String
    let instructions: String
}