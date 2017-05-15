//
//  CapturingHomepageService.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageService: HomepageService {

    private(set) var didLoad = false
    func loadHomepage() {
        didLoad = true
    }

}