//
//  LikesController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 26/08/21.
//

import UIKit

class LikesController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var likes = [Like]()
    let postId: String
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Likes"
        collectionView.backgroundColor = .white
        collectionView.register(LikeCell.self, forCellWithReuseIdentifier: "cell")
        
        fetchLikes()
        setupActivityIndicator()
    }
    
    fileprivate func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    fileprivate func fetchLikes()  {
        
        Service.shared.fetchLikes(postId: postId) { result in
            self.activityIndicatorView.stopAnimating()
            switch result{
            case .failure(let error):
                print("Failed to fetch likes ", error)
            case .success(let likes):
                self.likes = likes
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LikeCell
        let like = likes[indexPath.item]
        //cell.delegate = self
        cell.configureCell(like: like)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
