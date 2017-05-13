//
//  RootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

struct RootRouter {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func navigateToRoot() {
        window.rootViewController = UIViewController()
    }
    
}
