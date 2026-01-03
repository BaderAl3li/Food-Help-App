import UIKit

class NotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotificationCards()
        loadNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Set up main content view
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "notifications-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    private func setupNotificationCards() {
        for i in 1...3 {
            if let card = view.viewWithTag(100 + i) {
                card.layer.cornerRadius = 12
                card.layer.shadowColor = UIColor.black.cgColor
                card.layer.shadowOffset = CGSize(width: 0, height: 2)
                card.layer.shadowRadius = 4
                card.layer.shadowOpacity = 0.1
                card.backgroundColor = UIColor(red: 0.98, green: 0.975, blue: 1, alpha: 1)
            }
        }
    }
    
    private func loadNotifications() {
        FirebaseService.shared.fetchNotifications { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    print("Loaded \(notifications.count) notifications")
                    print("Loaded \(notifications.count) notifications")
                case .failure(let error):
                    print("Error loading notifications: \(error.localizedDescription)")
                }
            }
        }
    }
}

