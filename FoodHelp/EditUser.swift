import UIKit
import FirebaseFirestore

class EditUser: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var numberField: UITextField!

    // MARK: - Data (already passed from ManageUsers)
    var userData: [String: Any]?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        populateFields()
    }

    // MARK: - Populate TextFields
    func populateFields() {
        guard let user = userData else {
            print("❌ No user data")
            return
        }

        fNameField.text  = user["donor name"] as? String ?? ""
        emailField.text  = user["email"] as? String ?? ""
        numberField.text = user["number"] as? String ?? ""

        userId = user["id"] as? String
    }

    // MARK: - Save
    @IBAction func saveTapped(_ sender: Any) {

        let donorName  = fNameField.text ?? ""
        let email  = emailField.text ?? ""
        let number = numberField.text ?? ""

        // ❌ Validation
        if donorName.isEmpty || email.isEmpty || number.isEmpty {
            print("⚠️ All fields are required")
            return
        }

        guard let id = userId else {
            print("❌ Missing user ID")
            return
        }

        let updatedData: [String: Any] = [
            "donor name": donorName,
            "email": email,
            "number": number
        ]

        Firestore.firestore()
            .collection("users")   // CAPITAL U (your setup)
            .document(id)
            .updateData(updatedData) { error in
                if let error = error {
                    print("❌ Update failed:", error)
                } else {
                    print("✅ User updated")
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "If you delete the user you cannot bring it back.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { _ in

                guard let id = self.userId else {
                    self.showAlert(title: "Error", message: "Missing user ID")
                    return
                }

                Firestore.firestore()
                    .collection("users")   // must match your collection name exactly
                    .document(id)
                    .delete { error in
                        if let error = error {
                            print("❌ Delete failed:", error)
                            self.showAlert(
                                title: "Delete Failed",
                                message: "Please try again."
                            )
                        } else {
                            print("✅ User deleted")

                            // Go back to previous screen
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
            }
        )

        present(alert, animated: true)
    }

    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Clear
    
}
