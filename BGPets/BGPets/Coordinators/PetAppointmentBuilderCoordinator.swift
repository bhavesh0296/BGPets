//
//  PetAppointmentBuilderCoordinator.swift
//  BGPets
//
//  Created by bhavesh on 29/08/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import UIKit

public class PetAppointmentBuilderCoordinator: Coordinator {

    public let builder: PetAppointmentBuilder = PetAppointmentBuilder()
    public var children: [Coordinator] = []
    public var router: Router

    public init(router: Router) {
        self.router = router
    }

    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = SelectVisitTypeViewController.instantiate(delegate: self)
        router.present(viewController,
                       animated: animated,
                       onDismissed: onDismissed)
    }
}

extension PetAppointmentBuilderCoordinator: SelectVisitTypeViewControllerDelegate {
    public func selectVisitTypeViewController(_ controller: SelectVisitTypeViewController, didSelect visitType: VisitType) {

        builder.visitType = visitType

        switch visitType {
        case .sick:
            presentSelectPainLevelCoordinator()
        case .well:
            presentNoAppointmentViewController()
        }
    }

    private func presentNoAppointmentViewController() {
        let viewController = NoAppointmentRequiredViewController.instantiate(delegate: self)
        router.present(viewController, animated: true)
    }

    private func presentSelectPainLevelCoordinator() {
        let viewController = SelectPainLevelViewController.instantiate(delegate: self)
        router.present(viewController, animated: true)
    }

}

extension PetAppointmentBuilderCoordinator: NoAppointmentRequiredViewControllerDelegate {
    public func noAppointmentViewControllerDidPressOkay(_ controller: NoAppointmentRequiredViewController) {
        router.dismiss(animated: true)
    }


}

extension PetAppointmentBuilderCoordinator: SelectPainLevelViewControllerDelegate {
    public func selectPainLevelViewController(_ controller: SelectPainLevelViewController, didSelect painLevel: PainLevel) {
        builder.painLevel = painLevel

        switch painLevel {

        case .none, .little:
            presentFakingItViewController()
        case .moderate, .severe, .worstPossible:
            presentNoAppointmentViewController()
        }
    }

    private func presentFakingItViewController() {
        let viewController = FakingItViewController.instantiate(delegate: self)
        router.present(viewController, animated: true)
    }

}

extension PetAppointmentBuilderCoordinator: FakingItViewControllerDelegate {
    public func fakingItViewControllerPressedIsFake(_ controller: FakingItViewController) {
        router.dismiss(animated: true)
    }

    public func fakingItViewControllerPressedNotFake(_ controller: FakingItViewController) {
        presentNoAppointmentViewController()
    }


}
