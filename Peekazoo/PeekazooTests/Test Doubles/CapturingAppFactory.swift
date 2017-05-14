//
//  CapturingAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import UIKit

class CapturingAppFactory: AppFactory {
    
    private(set) var didMakeApplication = false
    private(set) var capturedWindow: UIWindow?
    func makeApplication(window: UIWindow) {
        didMakeApplication = true
        capturedWindow = window
    }
    
}
