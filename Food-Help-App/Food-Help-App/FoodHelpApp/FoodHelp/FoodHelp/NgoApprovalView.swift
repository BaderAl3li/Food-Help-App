import UIKit
import FirebaseFirestore

class NgoApprovalView: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    var currentNgoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPendingNgo()
    }

    func loadPendingNgo() {
        Firestore.firestore()
            .collection("users")
            .whereField("status", isEqualTo: "pending")
            .whereField("role", isEqualTo: "ngo")
            .limit(to: 1)
            .getDocuments { snapshot, _ in

                guard let doc = snapshot?.documents.first else {
                    self.showNoRequestsState()
                    return
                }

                let data = doc.data()
                self.currentNgoId = doc.documentID

                self.nameLabel.text  = data["org name"] as? String ?? "-"
                self.emailLabel.text = data["email"] as? String ?? "-"
                self.phoneLabel.text = data["number"] as? String ?? "-"
            }
    }

    func showNoRequestsState() {
        nameLabel.text = "No pending NGOs"
        emailLabel.text = ""
        phoneLabel.text = ""
        currentNgoId = nil
    }

    @IBAction func approveTapped(_ sender: Any) {
        updateStatus("approved")
    }

    @IBAction func declineTapped(_ sender: Any) {
        deleteNgo()
    }
    

    func updateStatus(_ status: String) {
        guard let ngoId = currentNgoId else { return }

        Firestore.firestore()
            .collection("users")
            .document(ngoId)
            .updateData(["status": status]) { _ in
                self.loadPendingNgo()
            }
    }
    
    func deleteNgo(){
        guard let ngoId = currentNgoId else {return}
        
        Firestore.firestore()
            .collection("users")
            .document(ngoId)
            .delete {_ in self.loadPendingNgo()
            }
    }
}
