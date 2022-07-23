//
//  API.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import Foundation

enum API{
    case getRecipe(q: String)
}

extension API: EndPoint{
    var baseURL: String {
        return "https://api.edamam.com"
    }
    var urlSubFolder: String {
        return "/api"
    }
    
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecipe(let q):
            return [URLQueryItem(name: "q", value: q),URLQueryItem(name: "app_id", value: "c5e3f076"),URLQueryItem(name: "app_key", value: "22db394a29326cdc705c2a801cb43fc3"),URLQueryItem(name: "type", value: "public")]
        
        default:
            return []
        }
    }
    
    
    
    
    var method: HTTPMethod {
        switch self {
        case .getRecipe:
                return  .get
        default :
            return  .get
        }
    }
    
    
    var path: String {
        switch self {
        case .getRecipe:
            return "recipes/v2"
        }
    }
    
    var body: [String: Any]? {
        switch self{
        default:
            return nil
        }
    }
    
    
    
}

