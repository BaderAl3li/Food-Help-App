import UIKit
import FirebaseFirestore

class CreateDonation: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var donationIdField: UITextField!
    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var donationTypeField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var charityField: UITextField!
    @IBOutlet weak var scheduleTimeField: UITextField!
    @IBOutlet weak var startingDateField: UITextField!
    @IBOutlet weak var endingDateField: UITextField!
    @IBOutlet weak var deliveryField: UITextField!

    @IBAction func createTapped(_ sender: Any) {

        let fields = [
            donationIdField.text,
            userIdField.text,
            donationTypeField.text,
            foodTypeField.text,
            quantityField.text,
            charityField.text,
            scheduleTimeField.text,
            startingDateField.text,
            endingDateField.text,
            deliveryField.text
        ]

        if fields.contains(where: { $0?.isEmpty ?? true }) {
            print("⚠️ All fields are required")
            return
        }

        let donationData: [String: Any] = [
            "id": donationIdField.text!,
            "userId": userIdField.text!,
            "donationType": donationTypeField.text!,
            "foodType": foodTypeField.text!,
            "quantity": quantityField.text!,
            "charity": charityField.text!,
            "scheduleTime": scheduleTimeField.text!,
            "startingDate": startingDateField.text!,
            "endingDate": endingDateField.text!,
            "delivery": deliveryField.text!
        ]

        Firestore.firestore()
            .collection("Donations")
            .addDocument(data: donationData) { error in
                if let error = error {
                    print("❌ Failed to create donation:", error)
                } else {
                    print("✅ Donation created")
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }

    @IBAction func clearTapped(_ sender: Any) {
        donationIdField.text = ""
        userIdField.text = ""
        donationTypeField.text = ""
        foodTypeField.text = ""
        quantityField.text = ""
        charityField.text = ""
        scheduleTimeField.text = ""
        startingDateField.text = ""
        endingDateField.text = ""
        deliveryField.text = ""
    }
}
