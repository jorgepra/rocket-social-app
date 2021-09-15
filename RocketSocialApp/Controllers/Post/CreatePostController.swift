//
//  CreatePostController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 12/08/21.
//

import UIKit
import Alamofire
import JGProgressHUD

protocol CreatePostControllerDelegate {
    func didFinishUploading()
}

class CreatePostController: UIViewController {
    
    let selectedImage       : UIImage
    let imageVIew           = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postButton          = UIButton(title: "Create Post", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: #colorLiteral(red: 0.02745098039, green: 0.5078932047, blue: 1, alpha: 1), target: self, action: #selector(handlePost))
    let placeholderLabel    = UILabel(text: "Enter your body text here...", font: .systemFont(ofSize: 14), textColor: .lightGray, numberOfLines: 0)
    let postTextView        = UITextView(text: nil, font: .systemFont(ofSize: 14), textColor: .black)
    let hud                 = NotificationHUD(style: .dark)
    var delegate            : CreatePostControllerDelegate?
                
    init(image: UIImage) {
        self.selectedImage = image
        super.init(nibName: nil, bundle: nil)
        self.imageVIew.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutUI()
    }
    
    fileprivate func layoutUI() {
        imageVIew.constrainHeight(250)
        postButton.constrainHeight(40)
        
        let innerStack = UIStackView(arrangedSubviews: [postButton, placeholderLabel, UIView()])
        innerStack.spacing = 16
        innerStack.axis = .vertical
        innerStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        innerStack.isLayoutMarginsRelativeArrangement = true
        
        let overallStack = UIStackView(arrangedSubviews: [imageVIew, innerStack])
        overallStack.spacing = 16
        overallStack.axis = .vertical
        
        view.addSubview(overallStack)
        overallStack.fillSuperview()
        
        
        view.addSubview(postTextView)
        postTextView.backgroundColor = .clear
        postTextView.delegate = self
        postTextView.anchor(top: placeholderLabel.bottomAnchor, leading: placeholderLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
    }
    
    @objc fileprivate func handlePost()  {
        guard let postText = postTextView.text, !postText.isEmpty else { return  }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        Service.shared.uploadPost(text: postText, image: self.selectedImage) { error in
            hud.dismiss()
            if let error = error{
                print("Failed to upload image", error)
            }
            
            self.dismiss(animated: true) {
                self.delegate?.didFinishUploading()
            }
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("Error at CreatePostController")
    }
}

extension CreatePostController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = postTextView.text.isEmpty ? 1 : 0
    }
}
