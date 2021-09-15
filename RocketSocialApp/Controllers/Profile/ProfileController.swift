//
//  ProfileController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 20/08/21.
//

import UIKit
import JGProgressHUD
import Alamofire

protocol ProfileControllerDelegate {
    func didFollowForProfile(userId: String, isFollowing: Bool?)
}

class ProfileController: BaseListController {
    
    var userId  : String!
    var user    : User?
    var posts   = [Post]()
    var hud     = NotificationHUD(style: .dark)
    
    init(userId: String) {
        super.init()
        self.userId = userId
    }
            
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    var delegate: ProfileControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
        fetchUserProfile()
        setupActivityIndicator()
        setupRefreshController()
    }
    
    fileprivate func configureCollectionViewController() {
        collectionView.backgroundColor = .white
        collectionView.register(UserPostCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    fileprivate func setupActivityIndicator() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupRefreshController()  {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
    @objc func fetchUserProfile()  {
        Service.shared.fetchProfile(userId: userId) { result in
            
            self.collectionView.refreshControl?.endRefreshing()
            self.activityIndicator.stopAnimating()
            switch result{
            case .failure(let err):
                print("Failed to fetch user profile:", err)
            case .success(let user):
                self.user = user
                self.posts = user.posts ?? []
                self.user?.isEditable = self.userId.isEmpty
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    // MARK:- header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ProfileHeader
        header.configureHeader(user: user)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let _ = user {
            return .init(width: view.frame.width, height: 300)
        } else {
            return .zero
        }
    }
    
    // MARK:- Datasource and Delegate CollectionView methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserPostCell
        let post = posts[indexPath.item]
        cell.configureCell(post: post)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let largeHeight: CGFloat = 1000
        let dummyCell = UserPostCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: largeHeight))
        dummyCell.configureCell(post: posts[indexPath.item])
        dummyCell.layoutIfNeeded()

        let height = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: largeHeight)).height

        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .init(0)
    }
}


// MARK:- ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate{
    func didChangeProfileImage(_ profileHeader: ProfileHeader) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didClickFollowButton(_ profileHeader : ProfileHeader) {
        guard let user = self.user else { return }
        
        Service.shared.followTo(user: user) { result in
            switch result{
            case .failure(let error):
                
                self.hud.show(view: self.view, text: "failed to follow or unfollow the user", isError: true)
                print("failed to follow or unfollow the user", error)
                
            case .success(let value):
                self.user?.isFollowing = value
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                self.delegate?.didFollowForProfile(userId: user.id, isFollowing: self.user?.isFollowing)
            }
        }
    }
}

// MARK:- UIImagePickerControllerDelegate

extension ProfileController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        guard let user = self.user else { return }

        dismiss(animated: true) {
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Uploading profile"
            hud.show(in: self.view)
            
            Service.shared.uploadProfile(fullName: user.fullName , bio: user.bio ?? "", image: image) { error in
                hud.dismiss()
                if let error = error{
                    print("Failed to upload profile", error)
                    return
                }
                
                self.dismiss(animated: true) {
                    self.fetchUserProfile()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- UserPostCellDelegate

extension ProfileController: UserPostCellDelegate{
    func handlePostLikes(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        let likesController = LikesController(postId: post.id)
        navigationController?.pushViewController(likesController, animated: true)
    }
    
    func handlePostLike(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        
        print(post)
    }
    
    func handlePostOptions(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
                   
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Delete Post", style: .destructive, handler: { (_) in
            
            Service.shared.deletePost(post: post) { error in
                if let error = error {
                    print("Can not delete the post", error)
                    return
                }
                
                // remove UI
                self.posts.remove(at: indexPath.item)
                
                DispatchQueue.main.async {
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }))
        
        alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handlePostComments(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    
}
