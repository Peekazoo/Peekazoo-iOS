//
//  InkbunnyAPIProtocolTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
import Peekazoo

class CapturingInkbunnyAPI: InkbunnyAPI {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulInkbunnyAPI: InkbunnyAPI {

    var items: [InkbunnySubmission]

    init(items: [InkbunnySubmission] = []) {
        self.items = items
    }

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.success(items))
    }

}

struct FailingInkbunnyAPI: InkbunnyAPI {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}
