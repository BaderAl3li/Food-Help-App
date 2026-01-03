import UIKit

class BasicInfoViewController: UIViewController {
    
    @IBOutlet weak var foodNameField: UITextField?
    @IBOutlet weak var descriptionField: UITextView?
    @IBOutlet weak var categoryButton: UIButton?
    @IBOutlet weak var nextButton: UIButton?
    
    private let categories = ["Fresh Produce", "Cooked Meals", "Bakery Items", "Canned/Packaged Foods", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCategoryPicker()
        setupKeyboardHandling()
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        setupFormFields()
        
        setupButtons()
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "basic-info-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    private func setupFormFields() {
        foodNameField?.layer.borderWidth = 1
        foodNameField?.layer.borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        foodNameField?.layer.cornerRadius = 10
        foodNameField?.layer.shadowColor = UIColor.black.cgColor
        foodNameField?.layer.shadowOffset = CGSize(width: 0, height: 2)
        foodNameField?.layer.shadowRadius = 5
        foodNameField?.layer.shadowOpacity = 0.25
        
        descriptionField?.layer.borderWidth = 1
        descriptionField?.layer.borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        descriptionField?.layer.cornerRadius = 10
        descriptionField?.layer.shadowColor = UIColor.black.cgColor
        descriptionField?.layer.shadowOffset = CGSize(width: 0, height: 2)
        descriptionField?.layer.shadowRadius = 5
        descriptionField?.layer.shadowOpacity = 0.25
        
        categoryButton?.layer.borderWidth = 1
        categoryButton?.layer.borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        categoryButton?.layer.cornerRadius = 10
        categoryButton?.layer.shadowColor = UIColor.black.cgColor
        categoryButton?.layer.shadowOffset = CGSize(width: 0, height: 2)
        categoryButton?.layer.shadowRadius = 5
        categoryButton?.layer.shadowOpacity = 0.25
    }
    
    private func setupButtons() {
        nextButton?.layer.cornerRadius = 18
        nextButton?.layer.shadowColor = UIColor.black.cgColor
        nextButton?.layer.shadowOffset = CGSize(width: 0, height: 1)
        nextButton?.layer.shadowRadius = 1
        nextButton?.layer.shadowOpacity = 0.06
    }
    
    private func setupCategoryPicker() {
        let alertController = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            let action = UIAlertAction(title: category, style: .default) { [weak self] _ in
                self?.categoryButton?.setTitle(category, for: .normal)
                self?.categoryButton?.setTitleColor(.label, for: .normal)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        categoryButton?.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
    }
    
    @objc private func showCategoryPicker() {
        let alertController = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            let action = UIAlertAction(title: category, style: .default) { [weak self] _ in
                self?.categoryButton?.setTitle(category, for: .normal)
                self?.categoryButton?.setTitleColor(.label, for: .normal)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let foodName = foodNameField?.text, !foodName.isEmpty else {
            showAlert(message: "Please enter food name")
            return
        }
        
        guard let categoryTitle = categoryButton?.titleLabel?.text, categoryTitle != "Select Category ▼" else {
            showAlert(message: "Please select a category")
            return
        }
        
        performSegue(withIdentifier: "basic-to-photos", sender: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Required Field", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}