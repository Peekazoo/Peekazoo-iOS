//
//  HomepagePresenter.swift
//  Peekazoo
//
//  Created by Thomas Sherwood on 15/05/2017.
//  Copyright © 2017 Peekazoo. All rights reserved.
//

class HomepagePresenter: HomepageInterfaceDelegate, HomepageServiceLoadingDelegate {

    var service: HomepageService
    var interface: HomepageInterface
    var didLoadSuccessfully = false

    init(interface: HomepageInterface, service: HomepageService) {
        self.interface = interface
        self.service = service
        self.interface.delegate = self
        reloadHomepage()
    }

    func homepageServiceDidLoadSuccessfully(content: [Any]) {
        didLoadSuccessfully = content.count > 0
        interface.hideLoadingErrorPlaceholder()
        interface.prepareForUpdates()
        content.indices.forEach(interface.insertItem(at:))

        if content.count > 0 {
            interface.hideNoContentPlaceholder()
        } else {
            interface.showNoContentPlaceholder()
        }
    }

    func homepageServiceDidFailToLoad() {
        interface.hideNoContentPlaceholder()

        if didLoadSuccessfully == false {
            interface.showLoadingErrorPlaceholder()
        }
    }

    func homepageInterfaceDidInvokePullToRefresh() {
        reloadHomepage()
    }

    private func reloadHomepage() {
        service.loadHomepage(delegate: self)
    }

}
