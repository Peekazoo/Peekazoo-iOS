//
//  WeasylServiceProtocol.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

enum WeasylHomepageLoadResult {
    case success([WeasylHomepageItem])
    case failure
}

protocol WeasylServiceProtocol {

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void)

}
