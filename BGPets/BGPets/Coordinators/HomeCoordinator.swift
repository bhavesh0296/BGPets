//
//  HomeCoordinator.swift
//  BGPets
//
//  Created by bhavesh on 29/08/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import UIKit

public class HomeCoordinator: Coordinator {

    public var children: [Coordinator] = []
    public let router: Router

    public init(router: Router) {
        self.router = router
    }

    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = HomeViewController.instantiate(delegate: self)
        router.present(viewController,
                       animated: animated,
                       onDismissed: onDismissed)
    }
}

extension HomeCoordinator: HomeViewControllerDelegate {
    public func homeViewControllerDidPressScheduleAppointment(_ viewController: HomeViewController) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        let coordinator = PetAppointmentBuilderCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }

}
