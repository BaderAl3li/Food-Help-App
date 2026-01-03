//
//  DonationPinView.swift
//  FoodHelper
//
//  Created by Hasan Hasan on 30/12/2025.
//

import UIKit
import MapKit

class DonationPinView: MKAnnotationView {

    static let identifier = "DonationPinView"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()

    override var annotation: MKAnnotation? {
        didSet {
            guard let ann = annotation as? DonationAnnotation else { return }
            titleLabel.text = ann.title
            addressLabel.text = ann.subtitle
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        centerOffset = CGPoint(x: 0, y: -40)

        cardView.frame = bounds
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 4
        addSubview(cardView)

        titleLabel.frame = CGRect(x: 12, y: 10, width: 176, height: 22)
        titleLabel.font = .boldSystemFont(ofSize: 15)

        addressLabel.frame = CGRect(x: 12, y: 35, width: 176, height: 18)
        addressLabel.font = .systemFont(ofSize: 13)
        addressLabel.textColor = .darkGray

        cardView.addSubview(titleLabel)
        cardView.addSubview(addressLabel)
    }
}
