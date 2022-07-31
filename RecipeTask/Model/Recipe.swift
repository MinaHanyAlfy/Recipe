//
//  Recipe.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-22.
//

import Foundation


// MARK: - RecipeLinks
struct RecipeLinks: Codable {
    let next: Next
}

struct RecipeResponse: Codable {
    let from, to, count: Int
    var links: RecipeLinks
    var hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}


// MARK: - Next
struct Next: Codable {
    let href: String
    let title: Title
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

struct Recipe: Codable {
        let url: String?
        let label: String?
        let image: String?
        let images: Images?
        let source: String?
        let healthLabels: [String]?
        let ingredientLines: [String]?
}
// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular: Large
    let large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}
