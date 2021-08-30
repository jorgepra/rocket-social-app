//
//  CommentCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 25/08/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    let usernameLabel = UILabel(text: "My Username", font: .boldSystemFont(ofSize: 15))
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "profile"), contentMode: .scaleAspectFit)
    let fromNowLabel = UILabel(text: "Posted 35 minutos ago", font: .systemFont(ofSize: 14),textColor: #colorLiteral(red: 0.6509079337, green: 0.6510220766, blue: 0.6509007215, alpha: 1))
    let textLabel = UILabel(text: "Post text in multiples lines, Post text in multiples lines, Post text in multiples lines, Post text in multiples lines", font: .systemFont(ofSize: 15), numberOfLines: 0)
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
        
        let infoVerticalStack = UIStackView(arrangedSubviews: [usernameLabel,fromNowLabel])
        infoVerticalStack.axis = .vertical
        infoVerticalStack.spacing = 4
        
        let hstack = UIStackView(arrangedSubviews: [profileImageView, infoVerticalStack , UIView()])
        hstack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        hstack.isLayoutMarginsRelativeArrangement = true
        hstack.alignment = .center
        hstack.spacing = 8
        
        let textStack = UIStackView(arrangedSubviews: [textLabel])
        textStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        textStack.isLayoutMarginsRelativeArrangement = true
        textStack.axis = .vertical
        
        let vstack = UIStackView(arrangedSubviews: [ hstack, textStack])
        vstack.axis = .vertical
        vstack.spacing = 16
        //vstack.distribution = .fill
        
        addSubview(vstack)
        vstack.fillSuperview(padding: .init(top: 16, left: 0, bottom: 16, right: 0))
                
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: textLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: -2, right: 0), size: .init(width: 0, height: 2))
    }
    
    func configureCell(comment: Comment)  {
        usernameLabel.text = comment.user.fullName
        profileImageView.sd_setImage(with: URL(string: comment.user.profileImageUrl ?? ""))
        fromNowLabel.text = "Posted \(comment.fromNow)"
        textLabel.text = comment.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
