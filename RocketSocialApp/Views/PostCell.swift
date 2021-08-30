//
//  PostCell.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 12/08/21.
//

import UIKit


//protocol PostCellOptionsDelegate: AnyObject {
//    func handlePostOptions(cell: PostCell)
//}

class PostCell: UITableViewCell {
    
//    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15), textColor: .black, textAlignment: .left, numberOfLines: 0)
//    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
//    let postTextLabel = UILabel(text: "Post text spanning multiple lines. Post text spanning multiple lines. Post text spanning multiple lines", font: .systemFont(ofSize: 15), textColor: .black, numberOfLines: 0)
//
//    lazy var optionsButton : UIButton = {
//        let bt = UIButton()
//        bt.setImage(UIImage(systemName: "ellipsis"), for: .normal)
//        bt.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
//        return bt
//    }()
//
//    weak var delegate: PostCellOptionsDelegate?
//
//    @objc fileprivate func handleOptions()  {
//        print("Handle delete options on post cell")
//        delegate?.handlePostOptions(cell: self)
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style,  reuseIdentifier: reuseIdentifier)
//        contentView.isUserInteractionEnabled = false
//
//        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
//        optionsButton.constrainWidth(30)
//
//        let hstack = UIStackView(arrangedSubviews: [usernameLabel, UIView(), optionsButton])
//        hstack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
//        hstack.isLayoutMarginsRelativeArrangement = true
//
//        let textStack = UIStackView(arrangedSubviews: [postTextLabel])
//        textStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
//        textStack.isLayoutMarginsRelativeArrangement = true
//        textStack.axis = .vertical
//
//        let vstack = UIStackView(arrangedSubviews: [hstack, postImageView, textStack])
//        vstack.axis = .vertical
//        vstack.spacing = 16
//        vstack.distribution  = .fill
//
//        addSubview(vstack)
//        vstack.fillSuperview(padding: .init(top: 16, left: 0, bottom: 16, right: 0))
//    }
//
    
//    required init?(coder: NSCoder) {
//        fatalError("Error Post Cell")
//    }
}
