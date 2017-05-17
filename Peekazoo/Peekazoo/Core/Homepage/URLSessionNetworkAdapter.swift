//
//  URLSessionNetworkAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 17/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

struct URLSessionNetworkAdapter: NetworkAdapter {

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { _, _, _ in }).resume()
    }

}
