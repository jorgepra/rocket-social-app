//
//  LikeCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 26/08/21.
//

import UIKit

class LikeCell: UICollectionViewCell {
       
    let usernameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 15))
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "profile"), contentMode: .scaleAspectFit)
    let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = #colorLiteral(red: 0.9528377652, green: 0.9530007243, blue: 0.9528275132, alpha: 1)
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.isUserInteractionEnabled = false
        profileImageView.constrainWidth(44)
        profileImageView.constrainHeight(44)
        profileImageView.layer.cornerRadius = 44 / 2
        
        let hstack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel, UIView()])
        hstack.spacing = 16
        hstack.alignment = .center
        hstack.distribution = .fill
        
        addSubview(hstack)
        hstack.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: profileImageView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: -2, right: 0), size: .init(width: 0, height: 2))
        
    }
    
    func configureCell(like: Like)  {
        usernameLabel.text = like.user.fullName
        profileImageView.sd_setImage(with: URL(string: like.user.profileImageUrl ?? ""))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
