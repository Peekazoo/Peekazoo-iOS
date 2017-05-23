//
//  PhoneAppFactory.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 14/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

public struct PhoneAppFactory: AppFactory {

    public func makeApplication(window: UIWindow) -> App {
        struct DummyTimeFormatter: TimeFormatter {
            func string(from date: Date) -> String { return "" }
        }

        let networkAdapter = URLSessionNetworkAdapter()
        let weasylAPI = WeasylAPI(networkAdapter: networkAdapter)
        let weasylAdapter = WeasylAPIAdapter(api: weasylAPI)
        let inkbunnyAPI = InkbunnyAPI(networkAdapter: networkAdapter)
        let inkbunnyAdapter = InkbunnyAPIAdapter(api: inkbunnyAPI)
        let service = PeekazooClient(feeds: [weasylAdapter, inkbunnyAdapter], delegateWorker: MainThreadWorker())
        let serviceAdapter = PeekazooHomepageAdapter(service: service)

        return PhoneApp(rootRouter: WindowRootRouter(window: window),
                        homepageService: serviceAdapter,
                        timeFormatter: DummyTimeFormatter())
    }

}
