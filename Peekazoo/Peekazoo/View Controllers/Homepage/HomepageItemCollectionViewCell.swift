//
//  HomepageItemCollectionViewCell.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

import UIKit

public class HomepageItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet public weak var itemTitleLabel: UILabel!
    @IBOutlet public weak var itemCreationDateLabel: UILabel!

    func configure(with viewModel: HomepageInterfaceItemViewModel?) {
        itemTitleLabel.text = viewModel?.title
        itemCreationDateLabel.text = viewModel?.creationDate
    }

}
