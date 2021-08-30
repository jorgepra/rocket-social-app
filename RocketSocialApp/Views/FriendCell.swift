//
//  FriendCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 27/08/21.
//

import UIKit

class FriendCell: UICollectionViewCell {
    
    let usernameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 12), textAlignment: .center)
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "profile"), contentMode: .scaleAspectFit)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        contentView.isUserInteractionEnabled = false
        profileImageView.constrainWidth(72)
        profileImageView.constrainHeight(72)
        profileImageView.layer.cornerRadius = 72 / 2
        profileImageView.layer.borderWidth = 1
                
        let vstack = UIStackView(arrangedSubviews: [profileImageView,usernameLabel])
        vstack.axis = .vertical
        vstack.spacing = 4
        vstack.alignment = .center
        
        addSubview(vstack)
        vstack.fillSuperview()
    }
    
    func configureCell(user: User)  {
        usernameLabel.text = user.fullName
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl ?? ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
