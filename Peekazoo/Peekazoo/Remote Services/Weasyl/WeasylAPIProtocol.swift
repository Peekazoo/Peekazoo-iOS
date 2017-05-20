//
//  WeasylAPIProtocol.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

enum WeasylHomepageLoadResult {
    case success([WeasylSubmission])
    case failure
}

protocol WeasylAPIProtocol {

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void)

}
