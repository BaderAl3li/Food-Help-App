import UIKit
import FirebaseFirestore

class EditUser: UIViewController {

    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var numberField: UITextField!

    var userData: [String: Any]?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
    }

    func populateFields() {
        guard let user = userData else {
            return
        }

        fNameField.text  = user["donor name"] as? String ?? ""
        emailField.text  = user["email"] as? String ?? ""
        numberField.text = user["number"] as? String ?? ""

        userId = user["id"] as? String
    }

    @IBAction func saveTapped(_ sender: Any) {

        let donorName = fNameField.text ?? ""
        let email     = emailField.text ?? ""
        let number    = numberField.text ?? ""

        if donorName.isEmpty || email.isEmpty || number.isEmpty {
            return
        }

        guard let id = userId else {
            return
        }

        let updatedData: [String: Any] = [
            "donor name": donorName,
            "email": email,
            "number": number
        ]

        Firestore.firestore()
            .collection("users")
            .document(id)
            .updateData(updatedData) { _ in
                self.navigationController?.popViewController(animated: true)
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
                    .collection("users")
                    .document(id)
                    .delete { _ in
                        self.performSegue(withIdentifier: "deleteClicke", sender: sender)                    }

                
            }
        )

        present(alert, animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
