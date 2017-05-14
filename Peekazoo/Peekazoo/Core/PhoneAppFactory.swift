//
//  PhoneAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

struct PhoneAppFactory: AppFactory {
    
    func makeApplication(window: UIWindow) -> App {
        class DummyApp: App {
            func launch() { }
        }
        
        return DummyApp()
    }
    
}
