import UIKit
import FirebaseFirestore

class EditDonation: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var donationTypeField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var charityField: UITextField!
    @IBOutlet weak var scheduleTimeField: UITextField!
    @IBOutlet weak var startingDateField: UITextField!
    @IBOutlet weak var endingDateField: UITextField!
    @IBOutlet weak var deliveryField: UITextField!
    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var donationIdField: UITextField!

    // MARK: - Data
    var donationData: [String: Any]?
    var donationDocId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
    }

    func populateFields() {
        guard let donation = donationData else { return }

        donationTypeField.text = donation["donationType"] as? String ?? ""
        foodTypeField.text     = donation["foodType"] as? String ?? ""
        quantityField.text     = donation["quantity"] as? String ?? ""
        charityField.text      = donation["charity"] as? String ?? ""
        scheduleTimeField.text = donation["scheduleTime"] as? String ?? ""
        startingDateField.text = donation["startingDate"] as? String ?? ""
        endingDateField.text   = donation["endingDate"] as? String ?? ""
        deliveryField.text     = donation["delivery"] as? String ?? ""

        // ✅ NORMAL FIELDS
        donationIdField.text = donation["id"] as? String ?? ""
        userIdField.text     = donation["userId"] as? String ?? ""

        // ✅ Firestore document ID (for update only)
        donationDocId = donation["docId"] as? String
    }

    @IBAction func saveTapped(_ sender: Any) {
        guard let docId = donationDocId else { return }

        let fields = [
            donationTypeField.text,
            foodTypeField.text,
            quantityField.text,
            charityField.text,
            scheduleTimeField.text,
            startingDateField.text,
            endingDateField.text,
            deliveryField.text,
            donationIdField.text,
            userIdField.text
        ]

        if fields.contains(where: { $0?.isEmpty ?? true }) {
            print("⚠️ All fields are required")
            return
        }

        let updatedData: [String: Any] = [
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
            .document(docId)
            .updateData(updatedData) { _ in
                self.navigationController?.popViewController(animated: true)
            }
    }

}
