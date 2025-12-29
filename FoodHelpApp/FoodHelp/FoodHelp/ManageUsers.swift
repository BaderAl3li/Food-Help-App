import UIKit
import FirebaseFirestore

class ManageUsers: UIViewController,
                   UICollectionViewDataSource,
                   UICollectionViewDelegate,
                   UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var users: [[String: Any]] = []
    var selectedUser: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        fetchUsers()
    }

    // MARK: - Firestore
    func fetchUsers() {
        Firestore.firestore()
            .collection("Users") // ✅ CAPITAL U
            .getDocuments { snapshot, error in

                if let error = error {
                    print("❌ Firestore error:", error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No users found")
                    return
                }

                self.users = documents.map { doc in
                    var data = doc.data()
                    data["id"] = doc.documentID
                    return data
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserCell",
            for: indexPath
        )

        let user = users[indexPath.item]

        // 🔹 Find label inside the cell (NO UserCell class required)
        if let nameLabel = cell.viewWithTag(1) as? UILabel {
            nameLabel.text = user["fName"] as? String ?? "User"
        }

        cell.layer.cornerRadius = 12
        cell.backgroundColor = .secondarySystemBackground

        return cell
    }

    // MARK: - 2 PER ROW LAYOUT
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3
        let width = (collectionView.frame.width - totalSpacing) / 2

        return CGSize(width: width, height: 160)
    }

    // MARK: - Tap Cell → Edit User
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        selectedUser = users[indexPath.item]
        performSegue(withIdentifier: "editUser", sender: self)
    }

    // MARK: - Pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUser",
           let editUser = segue.destination as? EditUser {

            editUser.userData = selectedUser
        }
    }
}
