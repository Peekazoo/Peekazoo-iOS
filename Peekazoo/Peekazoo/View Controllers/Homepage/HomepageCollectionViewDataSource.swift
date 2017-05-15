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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard viewModel != nil else { return 0 }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? HomepageItemCollectionViewCell else {
            fatalError()
        }

        cell.itemTitleLabel.text = "Some title"
        return cell
    }

}
