//
//  CustomInputAccessView.swift
//  LBTA-SwipeMatchFirestore
//
//  Created by Jorge on 25/06/2021.
//  Copyright © 2021 jorgepram. All rights reserved.
//

import UIKit

class CustomInputAccessoryView: UIView {
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    let textView = UITextView()
    let sendButton = UIButton(type: .system)
    
    let placeHolderLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Enter Message"
        lb.font = .systemFont(ofSize: 16)
        lb.textColor = .lightGray
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.lightGray.cgColor
        autoresizingMask = .flexibleHeight
                    
        //textView.text = "MAKE SURE TO SEE THIS"
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        //to dismiss placeholder
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        sendButton.constrainWidth(60)
        sendButton.constrainHeight(60)
        
        let stackView = UIStackView(arrangedSubviews: [
            textView,sendButton
        ])
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.isLayoutMarginsRelativeArrangement = true
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 16))
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
    }
    
    @objc fileprivate func handleTextChange()  {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
