//
//  HomepageViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct HomepageViewModel: HomepageInterfaceViewModel {

    var content: [Any]
    var isEmpty: Bool { return content.isEmpty }

    var numberOfItems: Int {
        return content.count
    }

}
