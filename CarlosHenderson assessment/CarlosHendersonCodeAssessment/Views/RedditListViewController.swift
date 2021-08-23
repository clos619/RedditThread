//
//  ViewController.swift
//
//  Created by Carlos Henderson
//

import UIKit
import Combine

class RedditListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.prefetchDataSource = self
        tableview.register(RedditCell.self, forCellReuseIdentifier: RedditCell.identifier)
        return tableview
    }()
    private let redditFeedViewModel = RedditFeedViewModel()
    private var publishers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setupBinding()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        // configure constraint
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupBinding() {
        redditFeedViewModel
            .feedsBinding
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &publishers)
        
        redditFeedViewModel.loadFeeds()
        
        redditFeedViewModel
            .errorBinding
            .sink { [weak self] in
                self?.showErrorAlert()
            }
            .store(in: &publishers)
        
        redditFeedViewModel
            .rowUpdateBinding
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
            .store(in: &publishers)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: redditFeedViewModel.geterrorDescription(), preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptButton)
        present(alert, animated: true)
    }
}

extension RedditListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditFeedViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditCell.identifier, for: indexPath) as! RedditCell
        let title = redditFeedViewModel.getTitle(at: row)
        let numComments = redditFeedViewModel.getNumComments(at: row)
        let imageData = redditFeedViewModel.getImageData(at: row)
        cell.configureCell(title: title, numComments: numComments, imageData: imageData)
        return cell
    }
    
}

extension RedditListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexPath = IndexPath(row: redditFeedViewModel.count - 1, section: 0)
        guard indexPaths.contains(indexPath) else { return }
        redditFeedViewModel.loadFeeds()
    }
    
}
