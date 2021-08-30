//
//  Comment.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 25/08/21.
//

import UIKit

struct Comment: Decodable {
    let text: String
    let user: User
    let fromNow: String
}
