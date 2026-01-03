import UIKit

class OrganizationListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadOrganizations()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "organizations-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        setupOrganizationCards()
        
        setupFilterButtons()
        
        setupSearchBar()
    }
    
    private func setupOrganizationCards() {
        view.subviews.forEach { subview in
            if subview.accessibilityIdentifier?.contains("org-card") == true {
                subview.layer.cornerRadius = 12
                subview.layer.shadowColor = UIColor.black.cgColor
                subview.layer.shadowOffset = CGSize(width: 0, height: 2)
                subview.layer.shadowRadius = 4
                subview.layer.shadowOpacity = 0.1
                subview.backgroundColor = .systemBackground
            }
        }
    }
    
    private func setupFilterButtons() {
        view.subviews.forEach { subview in
            if let button = subview as? UIButton, button.accessibilityIdentifier?.contains("filter") == true {
                button.layer.cornerRadius = 20
                if button.backgroundColor == UIColor(red: 0.29, green: 0.14, blue: 0.62, alpha: 1) {
                    button.layer.shadowColor = UIColor.black.cgColor
                    button.layer.shadowOffset = CGSize(width: 0, height: 1)
                    button.layer.shadowRadius = 2
                    button.layer.shadowOpacity = 0.1
                }
            }
        }
    }
    
    private func setupSearchBar() {
        searchBar?.searchBarStyle = .minimal
        searchBar?.layer.cornerRadius = 12
        searchBar?.backgroundImage = UIImage()
        searchBar?.backgroundColor = UIColor.systemGray6
    }
    
    private func loadOrganizations() {
        FirebaseService.shared.fetchOrganizations { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let organizations):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}

class OrganizationProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupScrollViewContent()
        
        setupMetricCards()
    }
    
    private func setupScrollViewContent() {
        if let scrollView = view.subviews.first as? UIScrollView {
            scrollView.showsVerticalScrollIndicator = true
            scrollView.alwaysBounceVertical = true
        }
    }
    
    private func setupMetricCards() {
        view.subviews.forEach { subview in
            if subview.accessibilityIdentifier?.contains("metric") == true {
                subview.layer.cornerRadius = 12
                subview.layer.shadowColor = UIColor.black.cgColor
                subview.layer.shadowOffset = CGSize(width: 0, height: 2)
                subview.layer.shadowRadius = 4
                subview.layer.shadowOpacity = 0.1
                subview.backgroundColor = .systemBackground
            }
        }
    }
}

