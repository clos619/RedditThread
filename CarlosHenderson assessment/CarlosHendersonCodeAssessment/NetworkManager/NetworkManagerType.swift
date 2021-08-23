//
//  NetworkManagerType.swift
//
//  Created by Carlos Henderson
//

import Foundation
import Combine

protocol NetworkManagerType {
    func get(from url: URL) -> AnyPublisher<Data, Error>
}
