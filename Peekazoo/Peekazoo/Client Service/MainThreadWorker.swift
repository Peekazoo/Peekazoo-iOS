//
//  MainThreadWorker.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import Foundation

public struct MainThreadWorker: Worker {

    public init() {}

    public func execute(_ work: @escaping () -> Void) {
        if Thread.current.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

}
