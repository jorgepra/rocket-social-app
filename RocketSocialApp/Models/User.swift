//
//  User.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 7/08/21.
//

import Foundation

struct User: Decodable {
    let id, fullName, emailAddress: String
    var isFollowing, isEditable: Bool?
    var posts: [Post]?
    var following, followers: [User]?
    var bio, profileImageUrl: String?
}
