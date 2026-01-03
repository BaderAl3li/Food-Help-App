import UIKit

class PickupLocationViewController: UIViewController {
    
    @IBOutlet weak var addressField: UITextField?
    @IBOutlet weak var areaField: UITextField?
    @IBOutlet weak var instructionField: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "location-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        setupFormFields()
        setupMapPreview()
        setupSubmitButton()
    }
    
    private func setupFormFields() {
        let borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        
        addressField?.layer.borderWidth = 1
        addressField?.layer.borderColor = borderColor
        addressField?.layer.cornerRadius = 10
        
        areaField?.layer.borderWidth = 1
        areaField?.layer.borderColor = borderColor
        areaField?.layer.cornerRadius = 10
        
        instructionField?.layer.borderWidth = 1
        instructionField?.layer.borderColor = borderColor
        instructionField?.layer.cornerRadius = 10
    }
    
    private func setupMapPreview() {
        if let mapPreview = view.subviews.first(where: { $0.accessibilityIdentifier == "map-preview" }) {
            mapPreview.layer.cornerRadius = 12
            mapPreview.layer.borderWidth = 1
            mapPreview.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    private func setupSubmitButton() {
        if let submitButton = view.subviews.first(where: { $0.accessibilityIdentifier == "submit-button" }) as? UIButton {
            submitButton.layer.cornerRadius = 18
            submitButton.layer.shadowColor = UIColor.black.cgColor
            submitButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            submitButton.layer.shadowRadius = 1
            submitButton.layer.shadowOpacity = 0.06
        }
    }
}