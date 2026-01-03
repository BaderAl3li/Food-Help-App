//
//  PaymentMethodViewController.swift
//  Food Help
//
//  Created by Hamood Hammad on 1/2/26.
//

import UIKit

class PaymentMethodViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var cardStack: UIStackView!
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet private weak var numberTF: UITextField!
    @IBOutlet private weak var expiryTF: UITextField!
    @IBOutlet private weak var cvvTF: UITextField!

    @IBOutlet private weak var payButton: UIButton!

    // MARK: - Data
        private var amountBHD: Double = 0

        override func viewDidLoad() {
            super.viewDidLoad()

            // If you want card stack hidden until user chooses card:
            // cardStack.isHidden = true
            // payButton.isEnabled = false

            // Keyboard + delegates
            amountTF.keyboardType = .decimalPad
            numberTF.keyboardType = .numberPad
            expiryTF.keyboardType = .numberPad
            cvvTF.keyboardType = .numberPad
            cvvTF.isSecureTextEntry = true

            amountTF.delegate = self
            numberTF.delegate = self
            expiryTF.delegate = self
            cvvTF.delegate = self

            // Make SF symbol bigger
            let config = UIImage.SymbolConfiguration(pointSize: 34, weight: .medium)
            cardImageView.image = UIImage(systemName: "creditcard.fill", withConfiguration: config)
            cardImageView.tintColor = .label

            // Styling (optional)
            [amountTF, nameTF, numberTF, expiryTF, cvvTF].forEach { tf in
                tf?.layer.cornerRadius = 10
                tf?.layer.borderWidth = 1
                tf?.layer.borderColor = UIColor.systemGray4.cgColor
                tf?.clipsToBounds = true
                tf?.setLeftPadding(12)
            }

            payButton.layer.cornerRadius = 10
        }

        // MARK: - Actions

        /// Use only if you still have a "Card" selection button
        @IBAction private func cardTapped(_ sender: UIButton) {
            cardStack.isHidden = false
            payButton.isEnabled = true
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }

        @IBAction private func backToDashboardTapped(_ sender: UIButton) {
            dismiss(animated: true)
        }

        @IBAction private func payTapped(_ sender: UIButton) {
            // Validate amount
            guard let txt = amountTF.text, let value = Double(txt), value > 0 else {
                alert("Enter a valid amount")
                return
            }

            // Validate fields
            let holder = (nameTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if holder.isEmpty { alert("Enter card holder name"); return }

            let digits = (numberTF.text ?? "").replacingOccurrences(of: " ", with: "")
            if digits.count != 16 { alert("Card number must be 16 digits"); return }

            if !isValidExpiry(expiryTF.text ?? "") { alert("Expiry must be MM/YY"); return }

            let cvv = cvvTF.text ?? ""
            if !(cvv.count == 3 || cvv.count == 4) { alert("CVV must be 3 or 4 digits"); return }

            // Demo note: Do NOT store CVV anywhere in real apps.
            amountBHD = value

            performSegue(withIdentifier: "toOTP", sender: self)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toOTP",
               let otpVC = segue.destination as? verifyOTPViewController {
                otpVC.amountBHD = amountBHD
            }
        }

        // MARK: - Formatting + limits (BHD 3 decimals, card spacing, MM/YY, CVV length)

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {

            if string.isEmpty { return true } // backspace

            // Amount: digits + one dot, max 3 decimals
            if textField == amountTF {
                let current = textField.text ?? ""
                let updated = (current as NSString).replacingCharacters(in: range, with: string)

                let allowed = CharacterSet(charactersIn: "0123456789.")
                if string.rangeOfCharacter(from: allowed.inverted) != nil { return false }

                if updated.filter({ $0 == "." }).count > 1 { return false }

                if let dot = updated.firstIndex(of: ".") {
                    let decimals = updated[updated.index(after: dot)...]
                    if decimals.count > 3 { return false }
                }
                return true
            }

            // Only digits for number/expiry/cvv
            if textField == numberTF || textField == expiryTF || textField == cvvTF {
                if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
                    return false
                }
            }

            // Card number formatting #### #### #### ####
            if textField == numberTF {
                let current = textField.text ?? ""
                let updated = (current as NSString).replacingCharacters(in: range, with: string)
                let digits = updated.replacingOccurrences(of: " ", with: "")
                if digits.count > 16 { return false }

                var formatted = ""
                for (i, ch) in digits.enumerated() {
                    if i > 0 && i % 4 == 0 { formatted.append(" ") }
                    formatted.append(ch)
                }
                textField.text = formatted
                return false
            }

            // Expiry formatting MM/YY
            if textField == expiryTF {
                let current = textField.text ?? ""
                let updated = (current as NSString).replacingCharacters(in: range, with: string)
                let digits = updated.replacingOccurrences(of: "/", with: "")
                if digits.count > 4 { return false }

                var formatted = ""
                for (i, ch) in digits.enumerated() {
                    if i == 2 { formatted.append("/") }
                    formatted.append(ch)
                }
                textField.text = formatted
                return false
            }

            // CVV max 4
            if textField == cvvTF {
                let current = textField.text ?? ""
                let updated = (current as NSString).replacingCharacters(in: range, with: string)
                return updated.count <= 4
            }

            return true
        }

        private func isValidExpiry(_ exp: String) -> Bool {
            let parts = exp.split(separator: "/")
            guard parts.count == 2,
                  parts[0].count == 2,
                  parts[1].count == 2,
                  let mm = Int(parts[0]),
                  (1...12).contains(mm) else { return false }
            return true
        }

        private func alert(_ msg: String) {
            let a = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default))
            present(a, animated: true)
        }
    }

    // MARK: - Padding helper
private extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 1))
        leftView = v
        leftViewMode = .always
    }
}
