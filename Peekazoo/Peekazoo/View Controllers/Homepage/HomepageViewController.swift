//
//  HomepageViewController.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController, HomepageInterface {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }

    var delegate: HomepageInterfaceDelegate?

    func prepareForUpdates() {

    }

    func commitUpdates() {

    }

    func showLoadingErrorPlaceholder() {

    }

    func hideLoadingErrorPlaceholder() {

    }

    func showNoContentPlaceholder() {

    }

    func hideNoContentPlaceholder() {

    }

    func insertItem(at index: Int) {

    }

}
