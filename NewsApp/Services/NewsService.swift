//
//  NewsService.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import Foundation
class NewsService {
    private let apiKey = "pub_72228a2fbd301aa21cb257f57148992846b6e"   
    private let baseURL = "https://newsdata.io/api/1/news"
    private var nextPage: String?
    
    func fetchNews(completion: @escaping ([NewsItem]?) -> Void) {
        var urlString = "\(baseURL)?apikey=\(apiKey)"
        
        
        if let nextPage = nextPage {
            urlString += "&page=\(nextPage)"
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            }

            do {
                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                if newsResponse.status == "success" {
                    self.nextPage = newsResponse.nextPage 
                    completion(newsResponse.results)
                } else {
                    print("API Error: \(newsResponse.error?.message ?? "Unknown error")")
                    completion(nil)
                }
            } catch {
                print("Error decoding news: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
