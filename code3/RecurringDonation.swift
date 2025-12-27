import Foundation

struct RecurringDonation: Codable {
    var donationType: String
    var foodType: String
    var quantity: Int
    var preferredCharity: String
    var scheduleInterval: String
    var scheduleTime: String
    var startDate: Date
    var endDate: Date
    var deliveryCompany: String
    var status: String
}
