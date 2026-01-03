import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDonations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data when view appears
        loadDonations()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Safely setup main content view
        DispatchQueue.main.async { [weak self] in
            self?.setupMainContentView()
            self?.setupDonationCards()
        }
    }
    
    private func setupMainContentView() {
        guard let mainContentView = view.subviews.first(where: { $0.accessibilityIdentifier == "main-content-view" }) else {
            return
        }
        
        mainContentView.layer.cornerRadius = 30
        mainContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainContentView.clipsToBounds = true
    }
    
    private func setupDonationCards() {
        view.subviews.forEach { subview in
            if subview.accessibilityIdentifier?.contains("donation-card") == true {
                subview.layer.cornerRadius = 12
                subview.layer.shadowColor = UIColor.black.cgColor
                subview.layer.shadowOffset = CGSize(width: 0, height: 2)
                subview.layer.shadowRadius = 4
                subview.layer.shadowOpacity = 0.1
                subview.backgroundColor = .systemBackground
                subview.clipsToBounds = false
            }
        }
    }
    
    private func loadDonations() {
        FirebaseService.shared.fetchUserDonations { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let donations):
                    print("Successfully loaded \(donations.count) donations")
                    self?.updateUI(with: donations)
                case .failure(let error):
                    print("Failed to load donations: \(error.localizedDescription)")
                    self?.showError(error)
                }
            }
        }
    }
    
    private func updateUI(with donations: [Donation]) {
        // Update UI elements with donation data
        // This method should be implemented based on your storyboard setup
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: "Failed to load donations: \(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadDonations()
        })
        present(alert, animated: true)
    }
}