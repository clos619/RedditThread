//
//  RedditDataResponse.swift
//
//  Created by Carlos Henderson
//

import Foundation

struct RedditDataResponse: Decodable {
    let after: String
    let children: [RedditFeed]
}
