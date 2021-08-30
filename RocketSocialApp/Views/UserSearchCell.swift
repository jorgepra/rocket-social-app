//
//  UserSearchCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 19/08/21.
//

import UIKit

protocol UserSearchCellDelegate : AnyObject{
    func didFollowForCell(cell: UserSearchCell)
}

class UserSearchCell: UICollectionViewCell {
    
    let nameLabel = UILabel(text: "Full name", font: .boldSystemFont(ofSize: 16), textColor: .black)
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        return sv
    }()
    
    var delegate: UserSearchCellDelegate?
    
    
    @objc fileprivate func handleFollow()  {
        delegate?.didFollowForCell(cell: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.isUserInteractionEnabled = false

        
        followButton.constrainWidth(100)
        followButton.constrainHeight(34)
        followButton.layer.cornerRadius = 17
        followButton.layer.borderWidth = 1
        
        let hstack = UIStackView(arrangedSubviews: [nameLabel, UIView(), followButton])
        hstack.spacing = 16
        hstack.alignment = .center
        
        addSubview(hstack)
        hstack.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 2))
    }
    
    func configureCell(user: User)  {
        nameLabel.text = user.fullName
        
        if user.isFollowing == true {
            followButton.backgroundColor = .black
            followButton.setTitleColor(.white, for: .normal)
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.backgroundColor = .white
            followButton.setTitleColor(.black, for: .normal)
            followButton.setTitle("Follow", for: .normal)
        }
        
        
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
