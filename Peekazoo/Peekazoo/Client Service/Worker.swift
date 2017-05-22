//
//  Worker.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public protocol Worker {

    func execute(_ work: @escaping () -> Void)

}
