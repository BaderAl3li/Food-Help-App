import UIKit

class AddPhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var selectedImages: [UIImage] = []
    private let maxImages = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPhotoButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "photos-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        setupNextButton()
    }
    
    private func setupPhotoButtons() {
        for i in 1...maxImages {
            if let button = view.viewWithTag(i) as? UIButton {
                button.addTarget(self, action: #selector(photoButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc private func photoButtonTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImages.append(image)
        }
        picker.dismiss(animated: true)
    }
    
    private func setupNextButton() {
        if let nextButton = view.subviews.first(where: { $0.accessibilityIdentifier == "photos-next-button" }) as? UIButton {
            nextButton.layer.cornerRadius = 18
        }
    }
}

class QuantityExpiryViewController: UIViewController {
    
    @IBOutlet weak var quantityField: UITextField?
    @IBOutlet weak var datePickerButton: UIButton?
    @IBOutlet weak var recurringToggle: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        if let contentView = view.subviews.first(where: { $0.accessibilityIdentifier == "quantity-content" }) {
            contentView.layer.cornerRadius = 30
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        setupFormFields()
        
        setupNextButton()
    }
    
    private func setupFormFields() {
        quantityField?.layer.borderWidth = 1
        quantityField?.layer.borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        quantityField?.layer.cornerRadius = 10
        
        datePickerButton?.layer.borderWidth = 1
        datePickerButton?.layer.borderColor = UIColor(red: 0.73, green: 0.61, blue: 0.996, alpha: 1).cgColor
        datePickerButton?.layer.cornerRadius = 10
    }
    
    private func setupNextButton() {
        if let nextButton = view.subviews.first(where: { $0.accessibilityIdentifier == "quantity-next-button" }) as? UIButton {
            nextButton.layer.cornerRadius = 18
            nextButton.layer.shadowColor = UIColor.black.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            nextButton.layer.shadowRadius = 1
            nextButton.layer.shadowOpacity = 0.06
        }
    }
    
    private func setupDatePicker() {
        datePickerButton?.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
    }
    
    @objc private func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        
        let alertController = UIAlertController(title: "Select Expiry Date", message: nil, preferredStyle: .alert)
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self?.datePickerButton?.setTitle(formatter.string(from: datePicker.date), for: .normal)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

