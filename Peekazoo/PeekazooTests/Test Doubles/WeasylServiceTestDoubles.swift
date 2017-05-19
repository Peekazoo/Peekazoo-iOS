//
//  WeasylServiceTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
@testable import Peekazoo

class CapturingWeasylService: WeasylServiceProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulWeasylService: WeasylServiceProtocol {

    var items: [WeasylHomepageItem]

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        completionHandler(.success(items))
    }

}

struct FailingWeasylService: WeasylServiceProtocol {

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}