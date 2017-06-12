//
//  JSONFetcher.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 11/06/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct JSONFetcher {

    public enum Result<T> where T: Decodable {
        case success(T)
        case failure
    }

    private let networkAdapter: NetworkAdapter
    private let decoder: JSONDecoder

    public init(networkAdapter: NetworkAdapter) {
        self.init(decoder: JSONDecoder(), networkAdapter: networkAdapter)
    }

    public init(decoder: JSONDecoder, networkAdapter: NetworkAdapter) {
        self.decoder = decoder
        self.networkAdapter = networkAdapter
    }

    public func fetchJSON<T>(from url: URL, representing type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        let jsonDecoder = decoder
        networkAdapter.get(url) { (data, _) in
            guard let data = data else {
                completionHandler(.failure)
                return
            }

            do {
                let jsonObject = try jsonDecoder.decode(type, from: data)
                completionHandler(.success(jsonObject))
            } catch {
                completionHandler(.failure)
            }
        }
    }

}
