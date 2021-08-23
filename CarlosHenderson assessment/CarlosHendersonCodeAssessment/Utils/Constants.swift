//
//  Constants.swift
//
//  Created by Carlos Henderson
//

import Foundation

enum URLs {
    static let urlBase = "https://www.reddit.com/.json"
    static let keyAfter = "$AFTER_KEY"
    static let redditFeedURL = "\(urlBase)?after=\(keyAfter)"
}
