//
//  HomepagePresenter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

class HomepagePresenter: HomepageInterfaceDelegate, HomepageServiceLoadingDelegate {

    var homepageService: HomepageService
    var homepageInterface: HomepageInterface

    init(homepageInterface: HomepageInterface, homepageService: HomepageService) {
        self.homepageInterface = homepageInterface
        self.homepageService = homepageService
        self.homepageInterface.delegate = self
        reloadHomepage()
    }

    func homepageServiceDidLoadSuccessfully() {
        homepageInterface.prepareForUpdates()
    }

    func homepageServiceDidFailToLoad() {
        homepageInterface.showLoadingErrorPlaceholder()
    }

    func homepageInterfaceDidInvokePullToRefresh() {
        reloadHomepage()
    }

    private func reloadHomepage() {
        homepageService.loadHomepage(delegate: self)
    }

}
