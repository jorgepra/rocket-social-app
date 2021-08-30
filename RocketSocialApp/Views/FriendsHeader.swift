//
//  FriendsHeader.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 27/08/21.
//

import UIKit

class FriendsHeader: UICollectionReusableView {
    
    let friendsLabel = IndentedLabel(text: "Friends", font: .boldSystemFont(ofSize: 16))
    let friendsHorizontalController = FriendsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [friendsLabel, friendsHorizontalController.view])
        
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
