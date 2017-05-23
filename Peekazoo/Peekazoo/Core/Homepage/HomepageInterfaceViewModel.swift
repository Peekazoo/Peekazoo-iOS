//
//  HomepageInterfaceViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

public protocol HomepageInterfaceViewModel {

    var numberOfItems: Int { get }

    func item(at index: Int) -> HomepageInterfaceItemViewModel

}

public protocol HomepageInterfaceItemViewModel {

    var title: String { get }
    var creationDate: String { get }

}
