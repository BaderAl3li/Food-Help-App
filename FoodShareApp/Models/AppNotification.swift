import Foundation

struct FoodShareNotification: Codable {
    let id: String
    let userId: String
    let title: String
    let message: String
    let type: NotificationType
    let donationId: String?
    let timestamp: Date
    let isRead: Bool
    
    enum NotificationType: String, Codable {
        case donationRequest = "donation_request"
        case donationAccepted = "donation_accepted"
        case pickupScheduled = "pickup_scheduled"
        case donationCollected = "donation_collected"
        case general = "general"
    }
}