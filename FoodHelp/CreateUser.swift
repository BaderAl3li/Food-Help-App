import UIKit
import Firebase
import FirebaseFirestore

class CreateUser: UIViewController {

    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createTapped(_ sender: Any) {

        let fName    = fNameField.text ?? ""
        let email    = emailField.text ?? ""
        let number   = numberField.text ?? ""
        let password = passwordField.text ?? ""
        let role     = roleField.text ?? ""

        if fName.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty {
            return
        }

        let userData: [String: Any] = [
            "donor name": fName,
            "email": email,
            "number": number,
            "password": password,   // demo only
            "role": role.lowercased(),
            "status": "approved",
            "createdAt": Timestamp()
        ]

        Firestore.firestore()
            .collection("users")
            .addDocument(data: userData) { _ in
                self.navigationController?.popViewController(animated: true)
            }
    }

    @IBAction func clearTapped(_ sender: Any) {
        fNameField.text = ""
        emailField.text = ""
        numberField.text = ""
        roleField.text = ""
        passwordField.text = ""
    }
}
