//
//  CapturingApp.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class CapturingApp: App {
    
    private(set) var didLaunch = false
    func launch() {
        didLaunch = true
    }
    
}
