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
        class ManualTestingHomepageService: HomepageService {
            struct StubItem: HomepageItem {
                var contentIdentifier: String
                var title: String
            }

            func loadHomepage(delegate: HomepageServiceLoadingDelegate) {
                let threeSecondsFromNow = DispatchTime(uptimeNanoseconds: DispatchTime.now().rawValue + (NSEC_PER_SEC * 3))
                DispatchQueue.main.asyncAfter(deadline: threeSecondsFromNow) {
                    let items = [StubItem(contentIdentifier: "1", title: "First"),
                                 StubItem(contentIdentifier: "2", title: "Second"),
                                 StubItem(contentIdentifier: "3", title: "Third")]
                    delegate.homepageServiceDidLoadSuccessfully(content: items)
                }
            }
        }

        return PhoneApp(rootRouter: WindowRootRouter(window: window),
                        homepageService: ManualTestingHomepageService())
    }

}
