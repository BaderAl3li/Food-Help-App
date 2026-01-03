import UIKit

@IBDesignable
class BorderedView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 0.729, green: 0.612, blue: 0.996, alpha: 1) // #BA9CFE
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 10.0
    @IBInspectable var shadowOpacity: Float = 0.25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    @MainActor private func setupBorder() {
        backgroundColor = UIColor.white
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        
        setNeedsDisplay()
    }
}

@IBDesignable
class BorderedTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    @MainActor private func setupBorder() {
        backgroundColor = UIColor.white
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.729, green: 0.612, blue: 0.996, alpha: 1).cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

@IBDesignable
class BorderedTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    @MainActor private func setupBorder() {
        backgroundColor = UIColor.white
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.729, green: 0.612, blue: 0.996, alpha: 1).cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

@IBDesignable
class BorderedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupBorder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    @MainActor private func setupBorder() {
        backgroundColor = UIColor.white
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.729, green: 0.612, blue: 0.996, alpha: 1).cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
    }
}