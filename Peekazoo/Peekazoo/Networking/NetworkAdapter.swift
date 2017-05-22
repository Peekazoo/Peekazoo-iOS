//
//  NetworkAdapter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 18/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public protocol NetworkAdapter {

    func get(_ url: URL, completionHandler: @escaping (Data?, Error?) -> Void)

}
