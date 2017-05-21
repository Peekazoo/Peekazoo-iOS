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
        let weasylAPI = WeasylAPI(networkAdapter: networkAdapter)
        let weasylAdapter = WeasylAPIAdapter(api: weasylAPI)
        let service = PeekazooClient(feeds: [weasylAdapter], delegateWorker: MainThreadWorker())
        let serviceAdapter = PeekazooHomepageAdapter(service: service)

        return PhoneApp(rootRouter: WindowRootRouter(window: window),
                        homepageService: serviceAdapter)
    }

}
