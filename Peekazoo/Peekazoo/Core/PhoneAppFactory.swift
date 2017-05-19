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
        let networkAdapter = URLSessionNetworkAdapter()
        let weasylService = WeasylService(networkAdapter: networkAdapter)
        let weasylAdapter = WeasylServiceAdapter(service: weasylService)
        let service = PeekazooClient(feeds: [weasylAdapter])
        let serviceAdapter = PeekazooHomepageAdapter(service: service)

        return PhoneApp(rootRouter: WindowRootRouter(window: window),
                        homepageService: serviceAdapter)
    }

}
