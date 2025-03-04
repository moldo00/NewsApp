//
//  FavoriteNewsViewController.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import UIKit

class FavoriteNewsViewController: UITableViewController {
    private var favoriteNews: [NewsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func setupTableView() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        title = "Избранное"
    }

    private func loadFavorites() {
        favoriteNews = FavoriteNewsManager.shared.getFavorites()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        let newsItem = favoriteNews[indexPath.row]
        cell.configure(with: newsItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = favoriteNews[indexPath.row]
        let detailVC = NewsDetailViewController()
        detailVC.newsItem = newsItem
        navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let newsItem = favoriteNews[indexPath.row]
            FavoriteNewsManager.shared.removeFavorite(newsItem)
            favoriteNews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
