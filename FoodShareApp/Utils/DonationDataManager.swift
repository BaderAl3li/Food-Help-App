import Foundation
import UIKit

class DonationDataManager {
    static let shared = DonationDataManager()
    
    var currentDonation = DraftDonation()
    
    private init() {}
    
    func reset() {
        currentDonation = DraftDonation()
    }
}

struct DraftDonation {
    var foodName: String = ""
    var description: String = ""
    var category: String = ""
    var quantity: Int = 0
    var unit: String = ""
    var expiryDate: Date = Date()
    var photos: [UIImage] = []
    var address: String = ""
    var area: String = ""
    var instructions: String = ""
    var isRecurring: Bool = false
}