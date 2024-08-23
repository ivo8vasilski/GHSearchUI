//
//  UserInfo.swift
//  GitHubSearchUI
//
//  Created by Ivo Vasilski on 23.08.24.
//

import Foundation

struct UserInfo: Decodable {
    
    let followers: Int
    let following: Int
  
    
    
    enum CodingKeys: String, CodingKey {
        case followers = "followers"
        case following = "following"
    }
}

