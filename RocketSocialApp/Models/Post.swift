//
//  Post.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 7/08/21.
//

import Foundation

struct Post: Decodable {
    let id, text: String
    let createdAt: Int
    let user: User
    let imageUrl: String
    let fromNow: String
    var comments: [Comment]?
    var hasLiked: Bool?
    var numLikes: Int
}

