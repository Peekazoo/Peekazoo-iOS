//
//  CapturingAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingAppFactory: AppFactory {
    
    private(set) var didMakeApplication = false
    func makeApplication() {
        didMakeApplication = true
    }
    
}
