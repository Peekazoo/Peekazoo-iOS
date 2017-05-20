//
//  InkbunnyAPIProtocol.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 20/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol InkbunnyAPIProtocol {

    func loadHomepage(completionHandler: @escaping (InkbunnyHomepageLoadResult) -> Void)

}
