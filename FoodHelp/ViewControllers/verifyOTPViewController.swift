//
//  verifyOTPViewController.swift
//  Food Help
//
//  Created by Hamood Hammad on 1/2/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class verifyOTPViewController: UIViewController {

    
    @IBOutlet private weak var phoneTF: UITextField!
    @IBOutlet private weak var otpTF: UITextField!
    @IBOutlet private weak var sendOTPButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!

    
    var amountBHD: Double = 0

    
    private let db = Firestore.firestore()
    private var verificationID: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTF.keyboardType = .phonePad
        otpTF.keyboardType = .numberPad
        otpTF.textContentType = .oneTimeCode

        
        [phoneTF, otpTF].forEach { tf in
            tf?.layer.cornerRadius = 10
            tf?.layer.borderWidth = 1
            tf?.layer.borderColor = UIColor.systemGray4.cgColor
            tf?.clipsToBounds = true
            tf?.setLeftPadding(12)
        }

        sendOTPButton.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 10
    }

    

    @IBAction private func backToPaymentTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func sendOTPTapped(_ sender: UIButton) {
        guard let phone = phoneTF.text,
              phone.starts(with: "+"),
              phone.count >= 10 else {
            alert("Enter phone with country code, e.g. +973XXXXXXXX")
            return
        }

        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] id, error in
            guard let self = self else { return }

            if let error = error {
                self.alert(error.localizedDescription)
                return
            }

            self.verificationID = id
            self.alert("OTP sent")
        }
    }

    @IBAction private func confirmTapped(_ sender: UIButton) {
        guard let id = verificationID else {
            alert("Please send OTP first")
            return
        }

        guard let code = otpTF.text, code.count >= 4 else {
            alert("Enter OTP code")
            return
        }

        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: id, verificationCode: code)

        Auth.auth().signIn(with: credential) { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                self.alert(error.localizedDescription)
                return
            }

            self.savePaymentAndGoDashboard()
        }
    }

    private func savePaymentAndGoDashboard() {
        let uid = Auth.auth().currentUser?.uid ?? "unknown"

        db.collection("payments").addDocument(data: [
            "uid": uid,
            "amountBHD": amountBHD,
            "status": "confirmed",
            "createdAt": Timestamp(date: Date())
        ]) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.alert("Firestore: \(error.localizedDescription)")
                return
            }

            let a = UIAlertController(title: "Success",
                                      message: "Payment confirmed",
                                      preferredStyle: .alert)

            a.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.presentingViewController?.presentingViewController?.dismiss(animated: true)
            })

            self.present(a, animated: true)
        }
    }

    
    private func alert(_ msg: String) {
        let a = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}


private extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 1))
        leftView = v
        leftViewMode = .always
    }
}
