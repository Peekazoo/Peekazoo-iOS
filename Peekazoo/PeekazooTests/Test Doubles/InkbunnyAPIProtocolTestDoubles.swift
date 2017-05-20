//
//  InkbunnyAPIProtocolTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation
@testable import Peekazoo

class CapturingInkbunnyAPI: InkbunnyAPIProtocol {

    private(set) var didLoadHomepage = false
    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        didLoadHomepage = true
    }

}

struct SuccessfulInkbunnyAPI: InkbunnyAPIProtocol {

    var items: [InkbunnySubmission]

    init(items: [InkbunnySubmission] = []) {
        self.items = items
    }

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.success(items))
    }

}

struct FailingInkbunnyAPI: InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void) {
        completionHandler(.failure)
    }

}
