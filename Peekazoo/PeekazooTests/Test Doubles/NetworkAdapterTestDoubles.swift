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

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) { }

}

class CapturingNetworkAdapter: NetworkAdapter {

    private(set) var requestedURL: URL?
    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        requestedURL = url
    }

}

struct FailingNetworkAdapter: NetworkAdapter {

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        completionHandler(nil, error)
    }

}

class SuccessfulNetworkAdapter: NetworkAdapter {

    var data: Data?

    init(data: Data?) {
        self.data = data
    }

    init(contentsOfJSONFile fileName: String) {
        let bundle = Bundle(for: SuccessfulNetworkAdapter.self)
        let jsonURL = bundle.url(forResource: fileName, withExtension: "json")!
        data = try? Data(contentsOf: jsonURL)
    }

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, nil)
    }

}

class BlockingNetworkAdapter: NetworkAdapter {

    struct Invocation {
        var url: URL
        var completionHandler: (Data?, Error?) -> Void
    }

    var adapter: NetworkAdapter
    var invocation: Invocation?

    init(adapter: NetworkAdapter) {
        self.adapter = adapter
    }

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        invocation = Invocation(url: url, completionHandler: completionHandler)
    }

    func run() {
        guard let invocation = invocation else { return }
        adapter.get(invocation.url, completionHandler: invocation.completionHandler)
    }

}
