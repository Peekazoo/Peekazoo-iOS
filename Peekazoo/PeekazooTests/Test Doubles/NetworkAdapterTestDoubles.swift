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

    func get(_ url: URL) { }

}

class CapturingNetworkAdapter: NetworkAdapter {

    private(set) var requestedURL: URL?
    func get(_ url: URL) {
        requestedURL = url
    }

}
