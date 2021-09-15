//
//  Factory.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 1/09/21.
//

import UIKit

extension UILabel{
    convenience init(text: String,font: UIFont,textColor: UIColor = .black,textAlignment: NSTextAlignment = .natural, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.textColor = textColor
    }
}
extension UIImageView{
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode ,cornerRadius: CGFloat = 0) {
        self.init(image: image)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = contentMode
    }
}
extension UIButton{
    convenience init(title: String, titleColor: UIColor, font: UIFont, backgroundColor: UIColor = .white, target: Any?, action: Selector) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension UIButton{
    convenience init(image: UIImage?, tintColor: UIColor, backgroundColor: UIColor = .white, target: Any?, action: Selector) {
        self.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
extension UITextView{
    convenience init(text: String? = nil, font: UIFont, textColor: UIColor = .black) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
extension UIStackView {
    convenience init(arrangedSubviews: [UIView], spacing: CGFloat = 0, distribution: UIStackView.Distribution? = nil) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = spacing
        if let distribution = distribution {
            self.distribution = distribution
        }
    }
}

