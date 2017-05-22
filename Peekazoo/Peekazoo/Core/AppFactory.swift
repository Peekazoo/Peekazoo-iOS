//
//  AppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

public protocol AppFactory {

    func makeApplication(window: UIWindow) -> App

}
