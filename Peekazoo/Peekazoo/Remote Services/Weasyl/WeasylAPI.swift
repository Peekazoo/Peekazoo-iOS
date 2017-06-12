//
//  WeasylAPI.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public enum WeasylHomepageLoadResult {
    case success([WeasylSubmission])
    case failure
}

public protocol WeasylAPI {

    func loadHomepage(completionHandler: @escaping (WeasylHomepageLoadResult) -> Void)

}
