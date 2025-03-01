//
//  UserDefaults+Extensions.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let favoriteNews = "favoriteNews"
    }

    func saveFavoriteNews(_ newsItem: NewsItem) {
        var favorites = getFavoriteNews()
        favorites.append(newsItem)
        if let encoded = try? JSONEncoder().encode(favorites) {
            set(encoded, forKey: Keys.favoriteNews)
        }
    }

    func getFavoriteNews() -> [NewsItem] {
        if let data = data(forKey: Keys.favoriteNews),
           let favorites = try? JSONDecoder().decode([NewsItem].self, from: data) {
            return favorites
        }
        return []
    }
}
