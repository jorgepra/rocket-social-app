//
//  UserPostCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 20/08/21.
//

import UIKit
import SDWebImage

protocol UserPostCellDelegate {
    func handlePostOptions(cell: UserPostCell)
    func handlePostComments(cell: UserPostCell)
    func handlePostLike(cell: UserPostCell)
    func handlePostLikes(cell: UserPostCell)
}

class UserPostCell: UICollectionViewCell {
    
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15))
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "profile"), contentMode: .scaleAspectFit)
    let fromNowLabel = UILabel(text: "Posted 35 minutos ago", font: .systemFont(ofSize: 14),textColor: #colorLiteral(red: 0.6509079337, green: 0.6510220766, blue: 0.6509007215, alpha: 1))
    let postImageView = UIImageView(image: #imageLiteral(resourceName: "cover1"), contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "Post text in multiples lines, Post text in multiples lines, Post text in multiples lines, Post text in multiples lines", font: .systemFont(ofSize: 15), numberOfLines: 0)
    lazy var optionsButton = UIButton(image: UIImage(systemName: "ellipsis") ?? UIImage(), tintColor: .black, target: self, action: #selector(handleOptionsButton))
    lazy var likeButton = UIButton(image: UIImage(systemName: "heart.fill") ?? UIImage(), tintColor: .black, target: self, action: #selector(handleLikeButton))
    lazy var commentButton = UIButton(image: UIImage(systemName: "text.bubble") ?? UIImage(), tintColor: .black, target: self, action: #selector(goToCommentsButton))
    lazy var numberOfLikesButton = UIButton(title: "30 Likes", titleColor: .black, font: .systemFont(ofSize: 14, weight: .bold), target: self, action: #selector(goToNumLikesButton))
    let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = #colorLiteral(red: 0.9528377652, green: 0.9530007243, blue: 0.9528275132, alpha: 1)
        return sv
    }()
    
    var imageViewHeightAnchor : NSLayoutConstraint!
    var delegate: UserPostCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewHeightAnchor.constant = frame.width
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    // MARK:- button actions
    
    @objc fileprivate func handleOptionsButton()  {
        delegate?.handlePostOptions(cell: self)
    }
    
    @objc fileprivate func handleLikeButton()  {
        delegate?.handlePostLike(cell: self)
    }
    
    @objc fileprivate func goToCommentsButton()  {
        delegate?.handlePostComments(cell: self)
    }
    
    @objc fileprivate func goToNumLikesButton()  {
        delegate?.handlePostLikes(cell: self)
    }
    
    func configureCell(post: Post)  {
        usernameLabel.text = post.user.fullName
        postImageView.sd_setImage(with: URL(string: post.imageUrl))
        postTextLabel.text = post.text
        profileImageView.sd_setImage(with: URL(string: post.user.profileImageUrl ?? ""))
        fromNowLabel.text = "Posted \(post.fromNow)"
        numberOfLikesButton.setTitle("\(post.numLikes) Likes", for: .normal)
        
        if post.numLikes == 0{
            numberOfLikesButton.isHidden = true
        } else{
            numberOfLikesButton.isHidden = false
        }
                
        if post.hasLiked == true {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .black
        }
        
    }
        
    fileprivate func setupLayout() {
        contentView.isUserInteractionEnabled = false
        profileImageView.constrainWidth(58)
        profileImageView.constrainHeight(58)
        profileImageView.layer.cornerRadius = 58 / 2
        //profileImageView.layer.borderWidth = 1
        optionsButton.constrainWidth(30)
        likeButton.constrainWidth(30)
        commentButton.constrainWidth(30)
        
        // to be used in tableView instead collectionView
        //postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        imageViewHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant: 0)
        imageViewHeightAnchor.isActive = true
        
        let infoVerticalStack = UIStackView(arrangedSubviews: [usernameLabel,fromNowLabel])
        infoVerticalStack.axis = .vertical
        infoVerticalStack.spacing = 4
        
        //let hstack = UIStackView(arrangedSubviews: [usernameLabel, UIView(), optionsButton])
        let hstack = UIStackView(arrangedSubviews: [profileImageView, infoVerticalStack , optionsButton])
        hstack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        hstack.isLayoutMarginsRelativeArrangement = true
        hstack.alignment = .center
        hstack.spacing = 8
        
        let textStack = UIStackView(arrangedSubviews: [postTextLabel])
        textStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        textStack.isLayoutMarginsRelativeArrangement = true
        textStack.axis = .vertical
        
        let socialStack = UIStackView(arrangedSubviews: [likeButton, commentButton, UIView()])
        socialStack.spacing = 12
        socialStack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 16)
        socialStack.isLayoutMarginsRelativeArrangement = true
        
        let likesStack = UIStackView(arrangedSubviews: [numberOfLikesButton, UIView()])
        likesStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        likesStack.isLayoutMarginsRelativeArrangement = true
        
        
        let overallStack = UIStackView(arrangedSubviews: [ hstack, postImageView, textStack, socialStack, likesStack])
        overallStack.axis = .vertical
        overallStack.spacing = 8
        //vstack.distribution = .fill
        
        addSubview(overallStack)
        overallStack.fillSuperview(padding: .init(top: 16, left: 0, bottom: 16, right: 0))
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: postTextLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: -2, right: 0), size: .init(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
