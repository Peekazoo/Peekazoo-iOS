//
//  CapturingHomepageInterface.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingHomepageInterface: HomepageInterface {

    private(set) var didPrepareForUpdates = false
    func prepareForUpdates() {
        didPrepareForUpdates = true
    }

}