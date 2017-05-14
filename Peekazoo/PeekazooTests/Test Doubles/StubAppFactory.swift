//
//  StubAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo
import UIKit

class StubAppFactory: AppFactory {
    
    let app: App
    
    convenience init() {
        self.init(app: DummyApp())
    }
    
    init(app: App) {
        self.app = app
    }
    
    func makeApplication(window: UIWindow) -> App {
        return app
    }
    
}
