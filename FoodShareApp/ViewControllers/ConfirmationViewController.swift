import UIKit

class ConfirmationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "confirmation-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        setupSummaryCard()
        setupButtons()
    }
    
    private func setupSummaryCard() {
        if let summaryCard = view.subviews.first(where: { $0.accessibilityIdentifier == "summary-card" }) {
            summaryCard.layer.cornerRadius = 16
            summaryCard.layer.shadowColor = UIColor.black.cgColor
            summaryCard.layer.shadowOffset = CGSize(width: 0, height: 2)
            summaryCard.layer.shadowRadius = 4
            summaryCard.layer.shadowOpacity = 0.1
        }
    }
    
    private func setupButtons() {
        view.subviews.forEach { subview in
            if let button = subview as? UIButton {
                button.layer.cornerRadius = 18
                if button.backgroundColor == UIColor(red: 0.29, green: 0.14, blue: 0.62, alpha: 1) {
                    button.layer.shadowColor = UIColor.black.cgColor
                    button.layer.shadowOffset = CGSize(width: 0, height: 1)
                    button.layer.shadowRadius = 1
                    button.layer.shadowOpacity = 0.06
                } else {
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor(red: 0.29, green: 0.14, blue: 0.62, alpha: 1).cgColor
                }
            }
        }
    }
}