//
//  HomepageCollectionViewDataSource.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

class HomepageCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var viewModel: HomepageInterfaceViewModel?
    private let cellReuseIdentifier: String

    init(cellReuseIdentifier: String) {
        self.cellReuseIdentifier = cellReuseIdentifier
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard viewModel != nil else { return 0 }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? HomepageItemCollectionViewCell else {
            fatalError()
        }

        let itemViewModel = viewModel?.item(at: indexPath.item)
        cell.itemTitleLabel.text = itemViewModel?.title
        return cell
    }

}
