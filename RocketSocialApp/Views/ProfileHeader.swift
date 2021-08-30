//
//  HeaderProfile.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 20/08/21.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func didClickFollowButton(_ profileHeader: ProfileHeader)
    func didChangeProfileImage(_ profileHeader: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    let usernameLabel = UILabel(text: "Thor asgard", font: .boldSystemFont(ofSize: 14), textColor: .black)
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "profile"), contentMode: .scaleAspectFit)
    let followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 15), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    let editButton = UIButton(title: "Edit Profile", titleColor: .white, font: .boldSystemFont(ofSize: 15), backgroundColor: #colorLiteral(red: 0.1628218293, green: 0.6282940507, blue: 0.9688766599, alpha: 1), target: self, action: #selector(handleEdit))
    
    
    let postCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    let postsLabel = UILabel(text: "posts", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followersCountLabel = UILabel(text: "500", font: .boldSystemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    let followersLabel = UILabel(text: "followers", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followingCountLabel = UILabel(text: "750", font: .boldSystemFont(ofSize: 14), textColor: .black, textAlignment: .center)
    let followingLabel = UILabel(text: "following", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let bioLabel = UILabel(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book", font: .systemFont(ofSize: 13), textColor: .darkGray, textAlignment: .justified, numberOfLines: 0)
    
    var delegate: ProfileHeaderDelegate?
    
    let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        return sv
    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
        
    // MARK:- button actions
    
    @objc fileprivate func handleFollow()  {
        print("follow user click button")
        delegate?.didClickFollowButton(self)
    }
    
    @objc fileprivate func handleEdit()  {
        print("did click to change img")
        delegate?.didChangeProfileImage(self)
    }
    
    // MARK:- layout
    
    func configureHeader( user: User?)  {
        usernameLabel.text = user?.fullName
        postCountLabel.text = "\(user?.posts?.count ?? 0)"
        followersCountLabel.text = "\(user?.followers?.count ?? 0)"
        followingCountLabel.text = "\(user?.following?.count ?? 0)"
        profileImageView.sd_setImage(with: URL(string: user?.profileImageUrl ?? ""))
        bioLabel.text = user?.bio
        
        if user?.isFollowing == true {
            followButton.backgroundColor = .black
            followButton.setTitleColor(.white, for: .normal)
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.backgroundColor = .white
            followButton.setTitleColor(.black, for: .normal)
            followButton.setTitle("Follow", for: .normal)
        }
                
        if user?.isEditable == true {
            followButton.removeFromSuperview()
        } else {
            editButton.removeFromSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit)))
        profileImageView.constrainWidth(72)
        profileImageView.constrainHeight(72)
        profileImageView.layer.cornerRadius = 72 / 2
        profileImageView.layer.borderWidth = 1
        followButton.constrainHeight(28)
        followButton.constrainWidth(100)
        followButton.layer.cornerRadius = 28 / 2
        followButton.layer.borderWidth = 1
        
        usernameLabel.constrainHeight(28)
        editButton.constrainHeight(28)
        editButton.constrainWidth(118)
        editButton.layer.cornerRadius = 28 / 2
        
        let postsStack = UIStackView(arrangedSubviews: [postCountLabel, postsLabel])
        postsStack.axis = .vertical
        postsStack.spacing = 4
        
        let followersStack = UIStackView(arrangedSubviews: [followersCountLabel, followersLabel])
        followersStack.axis = .vertical
        followersStack.spacing = 4
        
        let followingStack = UIStackView(arrangedSubviews: [followingCountLabel, followingLabel])
        followingStack.axis = .vertical
        followingStack.spacing = 4
        
        let statisticsStack = UIStackView(arrangedSubviews: [postsStack,followersStack,followingStack])
        statisticsStack.spacing = 12
        statisticsStack.distribution = .fillProportionally //cambiar
        
        let overallStack = UIStackView(arrangedSubviews: [
                                        profileImageView,
                                        followButton,
                                        editButton,
                                        statisticsStack,
                                        usernameLabel,
                                        bioLabel])
        overallStack.axis = .vertical
        overallStack.alignment = .center
        overallStack.spacing = 12
        
        addSubview(overallStack)
        overallStack.fillSuperview(padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: bioLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor ,padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
