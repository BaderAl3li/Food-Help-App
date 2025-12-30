import UIKit
import FirebaseFirestore

class ManageDonations: UIViewController,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var donations: [[String: Any]] = []
    var selectedDonation: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        fetchDonations()
    }

    // MARK: - Firestore
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
                    data["id"] = doc.documentID   // ✅ IMPORTANT
                    return data
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
    }

    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return donations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DonationCell",
            for: indexPath
        )

        let donation = donations[indexPath.item]

        // 🔹 SHOW DONATION ID
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = donation["id"] as? String ?? "No ID"
        }

        cell.layer.cornerRadius = 12
        cell.backgroundColor = .secondarySystemBackground

        return cell
    }

    // MARK: - 2 per row layout
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

        selectedDonation = donations[indexPath.item]
        performSegue(withIdentifier: "editDonation", sender: self)
    }

    // MARK: - Pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDonation",
           let editDonation = segue.destination as? EditDonation {

            editDonation.donationData = selectedDonation
        }
    }
}
