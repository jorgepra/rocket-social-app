//
//  PostDetailsController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 25/08/21.
//

import UIKit
import JGProgressHUD

class PostDetailsController: BaseListController, UICollectionViewDelegateFlowLayout {
       
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        aiv.color = .darkGray
        return aiv
    }()
    
    lazy var customInputView : CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    @objc fileprivate func handleSend()  {
        guard let text = customInputView.textView.text, text.isEmpty == false else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Submitting..."
        hud.show(in: self.view)
        
        Service.shared.createComment(postId: postId, text: text) { error in
            hud.dismiss()
            
            if let error = error{
                print("failed to create comment", error)
                return
            }
            
            self.customInputView.textView.text = nil
            self.customInputView.placeHolderLabel.isHidden = true
            self.fetchDetails()
        }
    }
        
    override var inputAccessoryView: UIView?{
        get{
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    var postId: String!
    var comments = [Comment]()
    
    init(postId: String) {
        super.init()
        self.postId = postId
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
        fetchDetails()
        setupActivityIndicator()
    }
    
    fileprivate func configureCollectionViewController() {
        navigationItem.title                = "Comments"
        collectionView.keyboardDismissMode  = .interactive
        collectionView.backgroundColor      = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    fileprivate func setupActivityIndicator() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.anchor(top: collectionView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func fetchDetails()  {
        Service.shared.fetchPostDetails(postId: postId) { result in
            self.activityIndicator.stopAnimating()
            
            switch result{
            case .failure(let err):
                print(err)
            case.success(let post):
                self.comments = post.comments ?? []
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        cell.configureCell(comment: comment)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let largeHeight: CGFloat    = 1000
        let dummyCell               = CommentCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: largeHeight))
        dummyCell.configureCell(comment: comments[indexPath.item])
        dummyCell.layoutIfNeeded()

        let height = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: largeHeight)).height
        return .init(width: view.frame.width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
