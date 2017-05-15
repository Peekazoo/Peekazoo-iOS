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
    var viewModel: HomepageViewModel

    init(interface: HomepageInterface, service: HomepageService) {
        self.interface = interface
        self.service = service
        self.viewModel = HomepageViewModel(content: [])
        self.interface.delegate = self
        reloadHomepage()
    }

    func homepageServiceDidLoadSuccessfully(content: [Any]) {
        viewModel = HomepageViewModel(content: content)
        interface.hideLoadingErrorPlaceholder()

        if viewModel.isEmpty {
            interface.showNoContentPlaceholder()
        } else {
            interface.hideNoContentPlaceholder()
            interface.prepareForUpdates()
            content.indices.forEach(interface.insertItem(at:))
            interface.commitUpdates(using: viewModel)
        }
    }

    func homepageServiceDidFailToLoad() {
        interface.hideNoContentPlaceholder()

        if viewModel.isEmpty {
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
