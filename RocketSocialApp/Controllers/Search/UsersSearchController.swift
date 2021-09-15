//
//  UsersSearchController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 19/08/21.
//

import UIKit

class UsersSearchController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var users   = [User]()
    let hud     = NotificationHUD(style: .dark)
       
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
        fetchUsers()
    }

    fileprivate func configureCollectionViewController() {
        navigationItem.title = "Search"
        collectionView.backgroundColor = .white
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    fileprivate func fetchUsers() {
        Service.shared.searchForUsers { result in
            switch result{
            case .failure(let error):
                self.hud.show(view: self.view, text: "Can not fetch search data", isError: true)
                print("Can not fetch search data", error)
            case .success(let users):
                self.users = users
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        let profileController = ProfileController(userId: user.id)
        profileController.delegate = self
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserSearchCell
        let user = users[indexPath.item]
        cell.delegate = self
        cell.configureCell(user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension UsersSearchController: UserSearchCellDelegate{
    func didFollowForCell(cell: UserSearchCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let user = users[indexPath.item]
                
        Service.shared.followTo(user: user) { result in
            switch result{
            case .success(let value):
                self.users[indexPath.item].isFollowing = value
                
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [indexPath])
                }
                
            case .failure(let error):
                self.hud.show(view: self.view, text: "failed to follow or unfollow the user", isError: true)
                print("failed to follow or unfollow the user", error)
            }
        }
    }
}

extension UsersSearchController: ProfileControllerDelegate{
    func didFollowForProfile(userId: String, isFollowing: Bool?) {
        if let index = self.users.firstIndex(where: {$0.id == userId}) {
            
            let indexPath = IndexPath(item: index, section: 0)
            self.users[indexPath.item].isFollowing = isFollowing
            
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        
    }
}
