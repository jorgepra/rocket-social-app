//
//  HomeController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 5/08/21.
//

import UIKit

class HomeController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    var friends = [User]()
    
    let hudNotification = NotificationHUD(style: .dark)
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UserPostCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(FriendsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.allowsSelection = false
        
        navigationItem.rightBarButtonItems = [
            .init(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearch)),
        ]
        
        navigationItem.leftBarButtonItem = .init(title: "Log In", style: .plain, target: self, action: #selector(goToLogin))
        navigationController?.navigationBar.tintColor = .black
        
        handleFetchData()
        showCookies()
        setupActivityIndicator()
        setupRefreshController()
    }
    
    fileprivate func setupActivityIndicator()  {
        collectionView.addSubview(activityIndicator)
        activityIndicator.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupRefreshController()  {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleFetchData), for: .valueChanged)
        self.collectionView.refreshControl = rc
    }
    
    // MARK:- Handle buttons
    
    fileprivate func showCookies()  {
        HTTPCookieStorage.shared.cookies?.forEach({ cookie in
            print(cookie.value)
        })
    }
    
    
    @objc fileprivate func handleSearch()  {
        let navController = UINavigationController(rootViewController: UsersSearchController())
        present(navController, animated: true)
    }
    
    @objc func handleFetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchPosts { result in
            dispatchGroup.leave()
            switch result{
            case .failure(let error):
                print(error)
                return
            case .success(let posts):
                self.posts = posts
            }
        }
        
        dispatchGroup.enter()
        Service.shared.fetchFriends { result in
            dispatchGroup.leave()
            switch result{
            case .failure(let error):
                print("Failed to fetch user friends", error)
            case .success(let friends):
                self.friends = friends
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.refreshControl?.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @objc fileprivate func goToLogin()  {
        let loginController = LoginController()
        loginController.delegate = self
        let navController = UINavigationController(rootViewController: loginController)        
        present(navController, animated: true, completion: nil)        
    }
    
    // MARK:- Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! FriendsHeader
        header.friendsHorizontalController.friends = friends
        header.friendsHorizontalController.collectionView.reloadData()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    // MARK:-  DataSource and Delegate CollectionView
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:  IndexPath) -> UICollectionViewCell {
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

// MARK:- UserPostCellDelegate

extension HomeController: UserPostCellDelegate{
    func handlePostLikes(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        let likesController = LikesController(postId: post.id)
        navigationController?.pushViewController(likesController, animated: true)
    }
    
    func handlePostLike(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        Service.shared.likePostFromFeed(post: post) { result in
            
            switch result{
            case .failure(let error):
                print("Failed to like feed post", error)
            case .success(let value):
                self.posts[indexPath.item].hasLiked = value
                self.posts[indexPath.item].numLikes += value ? 1: -1
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    func handlePostComments(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
        
        let postDetailsController = PostDetailsController(postId: post.id)
        navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    func handlePostOptions(cell: UserPostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let post = posts[indexPath.item]
                   
        let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "Remove From Feed", style: .destructive, handler: { (_) in
            
            Service.shared.deleteFromFeed(post: post) { error in
                if let error = error {
                    print(error)
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
}

// MARK:- LoginControllerDelegate

extension HomeController: LoginControllerDelegate{
    func didFinishLogin() {
        activityIndicator.startAnimating()
        handleFetchData()
    }
}
