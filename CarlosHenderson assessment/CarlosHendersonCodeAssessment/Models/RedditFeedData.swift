//
//  RedditData.swift
//
//  Created by Carlos Henderson
//

import Foundation

struct RedditFeedData: Decodable {
    let title: String?
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let thumbnail: String?
    let numComments: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth = "thumbnail_width"
        case thumbnail
        case numComments = "num_comments"
    }
}
