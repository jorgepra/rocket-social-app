//
//  CustomTextField.swift
//  LBTA-SwipeMatchFirestore
//
//  Created by Jorge on 30/04/2021.
//  Copyright © 2021 jorgepram. All rights reserved.
//

import UIKit

class IndentedTextField: UITextField {
    
    let padding: CGFloat
    let height: CGFloat
           
    init(text: String? = nil, placeholder: String, padding: CGFloat, cornerRadius: CGFloat, keyboardType: UIKeyboardType, backgroundColor: UIColor, isSecureTextEntry: Bool = false) {
        self.padding = padding
        self.height = 50
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.text = text
        self.layer.cornerRadius = 50/2
        self.keyboardType = keyboardType
        self.backgroundColor = backgroundColor
        self.isSecureTextEntry = isSecureTextEntry
    }
        
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: self.height)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
