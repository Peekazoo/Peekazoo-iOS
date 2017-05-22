//
//  HomepageViewController.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 13/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

private let homepageItemCellReuseIdentifier = "HomepageItemCell"

public class HomepageViewController: UIViewController, HomepageInterface {

    @IBOutlet public weak var collectionView: UICollectionView!
    private let dataSource = HomepageCollectionViewDataSource(cellReuseIdentifier: homepageItemCellReuseIdentifier)

    public override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "HomepageItemCollectionViewCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: homepageItemCellReuseIdentifier)
        collectionView.dataSource = dataSource
        title = "Home"
    }

    public var delegate: HomepageInterfaceDelegate?

    public func updateInterface(viewModel: HomepageInterfaceViewModel, applyingDifferences diffs: [Difference]) {
        dataSource.viewModel = viewModel
        collectionView.reloadData()
    }

    public func showLoadingErrorPlaceholder() {

    }

    public func hideLoadingErrorPlaceholder() {

    }

    public func showNoContentPlaceholder() {

    }

    public func hideNoContentPlaceholder() {

    }

}
