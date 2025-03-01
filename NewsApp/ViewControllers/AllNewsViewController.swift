//
//  AllNewsViewController.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import UIKit

class AllNewsViewController: UITableViewController {
    private var newsItems: [NewsItem] = []
    private let newsService = NewsService()
    private var isLoading = false
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        loadNews()
    }

    private func setupTableView() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    private func loadNews() {
        guard !isLoading else { return }
        isLoading = true

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        newsService.fetchNews { [weak self] news in
            guard let self = self else { return }
            self.isLoading = false

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }

            if let news = news {
                self.newsItems.append(contentsOf: news)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Failed to load news")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        let newsItem = newsItems[indexPath.row]
        cell.configure(with: newsItem)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = newsItems[indexPath.row]
        let detailVC = NewsDetailViewController()
        detailVC.newsItem = newsItem
        navigationController?.pushViewController(detailVC, animated: true)  
    }
}
