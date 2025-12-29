import UIKit

class EditUser: UIViewController {

    // ✅ PROPERTY (belongs to the class)
    var userData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        print("✅ EditUser loaded")
        print("✅ Received userData:", userData ?? "nil")

        // Example usage:
        // let firstName = userData?["fName"] as? String
    }
}
