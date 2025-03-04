//
//  NewItem.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

struct NewsItem: Codable, Equatable {
    let title: String
    let description: String?
    let pubDate: String
    let creator: [String]?
    let imageURL: String?
    let link: String?

    var id: String {
        return "\(title)-\(pubDate)"
    }

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case pubDate = "pubDate"
        case creator
        case imageURL = "image_url"
        case link
    }
}
