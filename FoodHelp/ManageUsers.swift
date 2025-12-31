import UIKit
import FirebaseFirestore

class ManageUsers: UIViewController,
                   UICollectionViewDataSource,
                   UICollectionViewDelegate,
                   UICollectionViewDelegateFlowLayout,
                   UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var users: [[String: Any]] = []
    var filteredUsers: [[String: Any]] = []
    var isSearching = false

    var selectedUser: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self

        fetchUsers()
    }

    func fetchUsers() {
        Firestore.firestore()
            .collection("users")
            .getDocuments { snapshot, _ in

                guard let documents = snapshot?.documents else {
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if text.isEmpty {
            isSearching = false
            filteredUsers.removeAll()
        } else {
            isSearching = true
            filteredUsers = users.filter { user in
                let name = (user["donor name"] as? String ?? "").lowercased()
                return name.contains(text.lowercased())
            }
        }

        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredUsers.removeAll()
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : users.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UserCell",
            for: indexPath
        )

        let user = isSearching
            ? filteredUsers[indexPath.item]
            : users[indexPath.item]

        if let nameLabel = cell.contentView.viewWithTag(1) as? UILabel {
            nameLabel.text = user["donor name"] as? String ?? "User"
        }

        cell.layer.cornerRadius = 12
        cell.backgroundColor = .secondarySystemBackground

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3
        let width = (collectionView.frame.width - totalSpacing) / 2

        return CGSize(width: width, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        selectedUser = isSearching
            ? filteredUsers[indexPath.item]
            : users[indexPath.item]

        performSegue(withIdentifier: "editUser", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUser",
           let editUser = segue.destination as? EditUser {

            editUser.userData = selectedUser
        }
    }
}
