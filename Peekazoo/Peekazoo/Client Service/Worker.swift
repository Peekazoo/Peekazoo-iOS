//
//  Worker.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 21/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol Worker {

    func execute(_ work: () -> Void)

}
