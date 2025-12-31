import UIKit
import FirebaseFirestore

class ManageDonations: UIViewController,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout,
                       UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var donations: [[String: Any]] = []
    var filteredDonations: [[String: Any]] = []
    var selectedDonation: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        searchBar.delegate = self
        searchBar.placeholder = "Search by Donation ID"

        fetchDonations()
    }

    func fetchDonations() {
        Firestore.firestore()
            .collection("Donations")
            .getDocuments { snapshot, _ in

                guard let documents = snapshot?.documents else {
                    return
                }

                self.donations = documents.map { doc in
                    var data = doc.data()
                    data["docId"] = doc.documentID
                    return data
                }

                self.filteredDonations = self.donations

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }

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

        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = donation["id"] as? String ?? "No ID"
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

        selectedDonation = filteredDonations[indexPath.item]
        performSegue(withIdentifier: "editDonation", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDonation",
           let editDonation = segue.destination as? EditDonation {

            editDonation.donationData = selectedDonation
        }
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredDonations = donations
        } else {
            let text = searchText.lowercased()
            filteredDonations = donations.filter {
                ($0["id"] as? String ?? "").lowercased().contains(text)
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
