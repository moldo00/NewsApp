//
//  FavoriteNewsManager.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 28/2/25.
//

import Foundation

import Foundation

class FavoriteNewsManager {
    static let shared = FavoriteNewsManager()
    
    private var favorites: [NewsItem] = []
    
    private init() {
        loadFavorites()
    }
    
    func addFavorite(_ newsItem: NewsItem) {
        if !isFavorite(newsItem) {
            favorites.append(newsItem)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ newsItem: NewsItem) {
        favorites.removeAll { $0.title == newsItem.title }
        saveFavorites()
    }
    
    func isFavorite(_ newsItem: NewsItem) -> Bool {
        return favorites.contains { $0.title == newsItem.title }
    }
    
    func getFavorites() -> [NewsItem] {
        return favorites
    }
    
    private func saveFavorites() {
        if let encodedData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encodedData, forKey: "favorites")
        }
    }
    
    private func loadFavorites() {
        if let savedData = UserDefaults.standard.data(forKey: "favorites"),
           let decodedFavorites = try? JSONDecoder().decode([NewsItem].self, from: savedData) {
            favorites = decodedFavorites
        }
    }
}
