//
//  RootRouter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

protocol RootRouter {

    func navigateToRoot() -> (viewController: UIViewController, router: Any)

}
