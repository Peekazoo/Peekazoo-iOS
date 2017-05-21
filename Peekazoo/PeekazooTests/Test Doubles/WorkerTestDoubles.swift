//
//  WorkerTestDoubles.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

@testable import Peekazoo

class AutoRunningWorker: Worker {

    func execute(_ work: () -> Void) {
        work()
    }

}

class BlockingWorker: Worker {

    func execute(_ work: () -> Void) {}

}
