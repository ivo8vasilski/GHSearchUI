//
//  User + GHResponse.swift
//  GitHubSearchUI
//
//  Created by Ivo Vasilski on 20.08.24.
//

import Foundation
import SwiftUI

struct User: Decodable, Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
  
    
 
    
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
    }
}

struct GHResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
