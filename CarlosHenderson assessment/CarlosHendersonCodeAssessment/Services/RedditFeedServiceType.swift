//
//  RedditFeedServiceType.swift
//
//  Created by Carlos Henderson
//

import Foundation
import Combine

protocol RedditFeedServiceType {
    var networkManager: NetworkManagerType { get }
    func getFeeds(from urlS: String) -> AnyPublisher<RedditResponse, Error>
    func getImage(from urlS: String) -> AnyPublisher<Data, Error>
}
