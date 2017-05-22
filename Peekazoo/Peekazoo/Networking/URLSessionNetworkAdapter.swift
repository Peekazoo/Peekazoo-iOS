//
//  URLSessionNetworkAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 17/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct URLSessionNetworkAdapter: NetworkAdapter {

    public init() {}

    public func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            completionHandler(data, error)
        }).resume()
    }

}
