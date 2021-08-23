//
//  RedditFeedViewModel.swift
//
//  Created by Carlos Henderson
//

import Foundation
import Combine

class RedditFeedViewModel {
    
    var feedsBinding = PassthroughSubject<Void, Never>()
    var errorBinding = PassthroughSubject<Void, Never>()
    var rowUpdateBinding = PassthroughSubject<Int, Never>()
    var count: Int { feeds.count }
    
    private let service: RedditFeedService
    private var publishers = Set<AnyCancellable>()
    private var feeds = [RedditFeedData]()
    private var errorDescription = ""
    private var after = ""
    private var isLoading = false
    private var imagesCache = NSCache<NSString, NSData>()
    
    init(service: RedditFeedService = RedditFeedService()) {
        self.service = service
    }
    
    private func downloadImage(urlImage: String, key: NSString, row: Int) {
        service
            .getImage(from: urlImage)
            .receive(on: RunLoop.main)
            .sink { _ in }
            receiveValue: { [unowned self] data in
                let nsData = NSData(data: data)
                imagesCache.setObject(nsData, forKey: key)
                rowUpdateBinding.send(row)
            }
            .store(in: &publishers)
    }
    
    func loadFeeds() {
        guard !isLoading else { return }
        isLoading = true
        
        let newURL = URLs.redditFeedURL.replacingOccurrences(of: URLs.keyAfter, with: after)
        
        service
            .getFeeds(from: newURL)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorDescription = error.localizedDescription
                    self?.errorBinding.send()
                    self?.isLoading = false
                }
            }
            receiveValue: { [weak self] response in
                self?.after = response.data.after
                let feeds = response.data.children.map { $0.data }
                self?.feeds.append(contentsOf: feeds)
                self?.feedsBinding.send()
                self?.isLoading = false
                print("Reddit: Feed loaded")
            }
            .store(in: &publishers)
    }
    
    func getImageData(at row: Int) -> Data? {
        
        guard let urlImage = feeds[row].thumbnail,
              urlImage.contains("https://")
        else { return nil }
        
        let key = NSString(string: urlImage)
        if let data = imagesCache.object(forKey: key) {
            return data as Data
        } else {
            downloadImage(urlImage: urlImage, key: key, row: row)
            return nil
        }
    }
    
    func getTitle(at row: Int) -> String? {
        return feeds[row].title
    }
    
    func getNumComments(at row: Int) -> String? {
        return "\(feeds[row].numComments)"
    }
    
    func geterrorDescription() -> String? {
        return errorDescription
    }
}
