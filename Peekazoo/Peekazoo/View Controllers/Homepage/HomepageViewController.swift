//
//  HomepageViewController.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController, HomepageInterface {

    @IBOutlet weak var collectionView: UICollectionView?
    private let dataSource = HomepageCollectionViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.dataSource = dataSource
        title = "Home"
    }

    var delegate: HomepageInterfaceDelegate?

    func prepareForUpdates() {

    }

    func insertItem(at index: Int) {

    }

    func commitUpdates(using viewModel: HomepageInterfaceViewModel) {

    }

    func showLoadingErrorPlaceholder() {

    }

    func hideLoadingErrorPlaceholder() {

    }

    func showNoContentPlaceholder() {

    }

    func hideNoContentPlaceholder() {

    }

}
