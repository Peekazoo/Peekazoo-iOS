//
//  WeasylAPITestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

class CapturingWeasylAPI: WeasylAPI {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulWeasylAPI: WeasylAPI {

    var items: [WeasylSubmission]

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        completionHandler(.success(items))
    }

}

struct FailingWeasylAPI: WeasylAPI {

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}
