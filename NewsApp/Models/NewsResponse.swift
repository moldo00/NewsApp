//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let results: [NewsItem]?
    let nextPage: String?
    let error: ErrorResponse?

    enum CodingKeys: String, CodingKey {
        case status
        case results
        case nextPage = "nextPage"
        case error
    }
}
struct ErrorResponse: Codable {
    let message: String
    let code: String
}
