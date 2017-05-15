//
//  HomepagePresenter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

struct HomepagePresenter: HomepageInterfaceDelegate, HomepageServiceLoadingDelegate {

    var service: HomepageService
    var interface: HomepageInterface

    init(interface: HomepageInterface, service: HomepageService) {
        self.interface = interface
        self.service = service
        self.interface.delegate = self
        reloadHomepage()
    }

    func homepageServiceDidLoadSuccessfully(content: [Any]) {
        interface.prepareForUpdates()

        if content.count > 0 {
            interface.hideNoContentPlaceholder()
        } else {
            interface.showNoContentPlaceholder()
        }
    }

    func homepageServiceDidFailToLoad() {
        interface.showLoadingErrorPlaceholder()
    }

    func homepageInterfaceDidInvokePullToRefresh() {
        reloadHomepage()
    }

    private func reloadHomepage() {
        service.loadHomepage(delegate: self)
    }

}
