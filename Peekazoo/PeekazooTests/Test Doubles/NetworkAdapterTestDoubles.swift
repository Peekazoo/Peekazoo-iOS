//
//  NetworkAdapterTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 16/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import Foundation

class DummyNetworkAdapter: NetworkAdapter {

    func get(_ url: URL, completionHandler: (Data?, Error?) -> Void) { }

}

class CapturingNetworkAdapter: NetworkAdapter {

    private(set) var requestedURL: URL?
    func get(_ url: URL, completionHandler: (Data?, Error?) -> Void) {
        requestedURL = url
    }

}

struct FailingNetworkAdapter: NetworkAdapter {

    func get(_ url: URL, completionHandler: (Data?, Error?) -> Void) {
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        completionHandler(nil, error)
    }

}

struct SuccessfulNetworkAdapter: NetworkAdapter {

    var data: Data?

    func get(_ url: URL, completionHandler: (Data?, Error?) -> Void) {
        completionHandler(data, nil)
    }

}
