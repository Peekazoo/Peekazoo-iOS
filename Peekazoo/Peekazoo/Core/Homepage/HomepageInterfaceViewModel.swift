//
//  HomepageInterfaceViewModel.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 19/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

protocol HomepageInterfaceViewModel {

    var numberOfItems: Int { get }

    func item(at index: Int) -> HomepageInterfaceItemViewModel

}

protocol HomepageInterfaceItemViewModel {

    var title: String { get }

}
