import UIKit
import FirebaseFirestore

class EditUser: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
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

        fNameField.text  = user["fName"] as? String ?? ""
        lNameField.text  = user["lName"] as? String ?? ""
        emailField.text  = user["email"] as? String ?? ""
        numberField.text = user["number"] as? String ?? ""

        userId = user["id"] as? String
    }

    // MARK: - Save
    @IBAction func saveTapped(_ sender: Any) {

        let fName  = fNameField.text ?? ""
        let lName  = lNameField.text ?? ""
        let email  = emailField.text ?? ""
        let number = numberField.text ?? ""

        // ❌ Validation
        if fName.isEmpty || lName.isEmpty || email.isEmpty || number.isEmpty {
            print("⚠️ All fields are required")
            return
        }

        guard let id = userId else {
            print("❌ Missing user ID")
            return
        }

        let updatedData: [String: Any] = [
            "fName": fName,
            "lName": lName,
            "email": email,
            "number": number
        ]

        Firestore.firestore()
            .collection("Users")   // CAPITAL U (your setup)
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
                do {
                    //logic
                } catch {
                    self.showAlert(title: "Signout Failed", message: "Retry in a few minutes")
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
