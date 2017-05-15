//
//  HomepageViewController.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

private let homepageItemCellReuseIdentifier = "HomepageItemCell"

class HomepageViewController: UIViewController, HomepageInterface {

    @IBOutlet weak var collectionView: UICollectionView!
    private let dataSource = HomepageCollectionViewDataSource(cellReuseIdentifier: homepageItemCellReuseIdentifier)

    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "HomepageItemCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: homepageItemCellReuseIdentifier)
        collectionView.dataSource = dataSource
        title = "Home"
    }

    var delegate: HomepageInterfaceDelegate?

    func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) {
        dataSource.viewModel = viewModel
        collectionView.reloadData()
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
