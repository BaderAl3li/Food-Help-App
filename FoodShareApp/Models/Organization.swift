import Foundation

struct Organization: Codable {
    let id: String
    let name: String
    let category: OrganizationCategory
    let rating: Double
    let address: String
    let phone: String
    let email: String
    let description: String
    let impactMetrics: ImpactMetrics
    let logoURL: String?
    
    enum OrganizationCategory: String, CaseIterable, Codable {
        case foodBanks = "Food Banks"
        case charity = "Charity"
        case community = "Community"
        
        static var all: [OrganizationCategory] {
            return [.foodBanks, .charity, .community]
        }
    }
}

struct ImpactMetrics: Codable {
    let collectionsCompleted: Int
    let mealsServed: Int
    let peopleHelped: Int
}