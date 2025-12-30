import UIKit
import FirebaseFirestore

class ManageDonations: UIViewController,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout,
                       UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Data
    var donations: [[String: Any]] = []
    var filteredDonations: [[String: Any]] = []
    var selectedDonation: [String: Any]?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        searchBar.delegate = self
        searchBar.placeholder = "Search by Donation ID"

        fetchDonations()
    }

    // MARK: - Fetch Donations
    func fetchDonations() {
        Firestore.firestore()
            .collection("Donations")
            .getDocuments { snapshot, error in

                if let error = error {
                    print("❌ Firestore error:", error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No donations found")
                    return
                }

                self.donations = documents.map { doc in
                    var data = doc.data()

                    // Store Firestore document ID separately (for updates)
                    data["docId"] = doc.documentID

                    // DO NOT touch data["id"] (this is your custom ID field)
                    return data
                }

                self.filteredDonations = self.donations

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredDonations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DonationCell",
            for: indexPath
        )

        let donation = filteredDonations[indexPath.item]

        // Label inside cell (tag = 1) shows DONATION ID FIELD
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = donation["id"] as? String ?? "No ID"
        }

        cell.layer.cornerRadius = 12
        cell.backgroundColor = .secondarySystemBackground

        return cell
    }

    // MARK: - 2 Per Row Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 10
        let totalSpacing = spacing * 3
        let width = (collectionView.frame.width - totalSpacing) / 2

        return CGSize(width: width, height: 160)
    }

    // MARK: - Tap → Edit Donation
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        selectedDonation = filteredDonations[indexPath.item]
        performSegue(withIdentifier: "editDonation", sender: self)
    }

    // MARK: - Pass Data to EditDonation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDonation",
           let editDonation = segue.destination as? EditDonation {

            editDonation.donationData = selectedDonation
        }
    }

    // MARK: - Search Bar (Search by Donation ID)
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredDonations = donations
        } else {
            let text = searchText.lowercased()
            filteredDonations = donations.filter { donation in
                let id = (donation["id"] as? String ?? "").lowercased()
                return id.contains(text)
            }
        }

        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredDonations = donations
        collectionView.reloadData()
    }
}
