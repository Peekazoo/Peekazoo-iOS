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

    convenience init(string: String) {
        self.init(data: string.data(using: .utf8))
    }

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

class JournallingNetworkAdapter: NetworkAdapter {

    var networkAdapter: NetworkAdapter

    init(networkAdapter: NetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    private(set) var getURLs = [URL]()
    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        getURLs.append(url)
        networkAdapter.get(url, completionHandler: completionHandler)
    }

    func lastGetURLContains(_ component: String) -> Bool {
        guard let url = getURLs.last else { return false }
        return url.absoluteString.contains(component)
    }

}

struct ControllableNetworkAdapter: NetworkAdapter {

    enum StubResponse {
        case data(Data)
        case error(Error)
    }

    private var responses = [URL: StubResponse]()

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let response = responses[url] else { return }

        switch response {
        case .data(let data):
            completionHandler(data, nil)

        case .error(let error):
            completionHandler(nil, error)
        }
    }

    mutating func stub(url: URL, with data: Data) {
        responses[url] = .data(data)
    }

    mutating func stub(url: URL, withContentsOfJSONFile name: String) {
        let bundle = Bundle(for: SuccessfulNetworkAdapter.self)
        let jsonURL = bundle.url(forResource: name, withExtension: "json")!
        if let data = try? Data(contentsOf: jsonURL) {
            stub(url: url, with: data)
        }
    }

    mutating func stub(url: URL, with error: Error) {
        responses[url] = .error(error)
    }

    mutating func stubFailure(url: URL) {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        stub(url: url, with: error)
    }

}
