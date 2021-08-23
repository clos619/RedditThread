//
//  NetworkManager.swift
//
//  Created by Carlos Henderson
//

import Foundation
import Combine

class NetworkManager {
    private let session = URLSession.shared
}

extension NetworkManager: NetworkManagerType {
    func get(from url: URL) -> AnyPublisher<Data, Error> {
        session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { failure in
                return NSError(domain: URLError.errorDomain, code: failure.code.rawValue, userInfo: failure.errorUserInfo)
            }
            .eraseToAnyPublisher()
    }
}
