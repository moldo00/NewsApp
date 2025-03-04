//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Moldolyev Askar on 27/2/25.
//

import UIKit

class NewsDetailViewController: UIViewController {
    var newsItem: NewsItem!

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let sourceButton = UIButton(type: .system)
    private var favoriteButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: newsItem)
        setupFavoriteButton()
        addObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 12
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newsImageView)

        
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        
        authorLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        authorLabel.textColor = .secondaryLabel
        authorLabel.numberOfLines = 0
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)

        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        
        sourceButton.setTitle("Перейти к источнику", for: .normal)
        sourceButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        sourceButton.backgroundColor = .systemBlue
        sourceButton.setTitleColor(.white, for: .normal)
        sourceButton.layer.cornerRadius = 8
        sourceButton.addTarget(self, action: #selector(openSource), for: .touchUpInside)
        sourceButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sourceButton)


        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            newsImageView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            sourceButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            sourceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sourceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sourceButton.heightAnchor.constraint(equalToConstant: 50),
            sourceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func configure(with newsItem: NewsItem) {
        titleLabel.text = newsItem.title
        descriptionLabel.text = newsItem.description
        authorLabel.text = "Автор: \(newsItem.creator?.joined(separator: ", ") ?? "Неизвестен")"

        if let imageURL = newsItem.imageURL {
            newsImageView.isHidden = false
            NewsService.shared.loadImage(from: imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.newsImageView.image = image
                }
            }
        } else {
            newsImageView.isHidden = true
        }
    }

    private func setupFavoriteButton() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: FavoriteNewsManager.shared.isFavorite(newsItem) ? "star.fill" : "star"),
                                        style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func toggleFavorite() {
        if FavoriteNewsManager.shared.isFavorite(newsItem) {
            FavoriteNewsManager.shared.removeFavorite(newsItem)
        } else {
            FavoriteNewsManager.shared.addFavorite(newsItem)
        }
        updateFavoriteButton()
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }

    private func updateFavoriteButton() {
        favoriteButton.image = UIImage(systemName: FavoriteNewsManager.shared.isFavorite(newsItem) ? "star.fill" : "star")
    }

    @objc private func openSource() {
        if let link = newsItem.link, let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdate), name: .favoritesUpdated, object: nil)
    }

    @objc private func handleFavoritesUpdate() {
        updateFavoriteButton()
    }
}

// Расширение для уведомлений
extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
