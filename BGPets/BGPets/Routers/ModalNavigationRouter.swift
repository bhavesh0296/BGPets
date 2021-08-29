//
//  ModalNavigationRouter.swift
//  BGPets
//
//  Created by bhavesh on 29/08/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import UIKit

public class ModalNavigationRouter: NSObject {
    public unowned let parentViewController: UIViewController

    private let navigationController = UINavigationController()
    private var onDismissedViewController: [UIViewController: (() -> Void)] = [:]

    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        navigationController.delegate = self
    }

}

extension ModalNavigationRouter: Router {

    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        if navigationController.viewControllers.count == 0 {
            presentModally(viewController, animated: animated)
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }

    private func presentModally(_ viewController: UIViewController, animated: Bool) {
        addCancelButton(to: viewController)
        navigationController.setViewControllers([viewController], animated: animated)
        parentViewController.present(navigationController,
                                     animated: animated,
                                     completion: nil)
    }

    private func addCancelButton(to viewController: UIViewController) {
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                          style: .plain,
                                                                          target: self,
                                                                          action: #selector(cancelClicked))
    }

    @objc private func cancelClicked() {
        performOnDismissed(for: navigationController.viewControllers.first!)
        dismiss(animated: true)
    }

    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissedViewController[viewController] else { return }
        onDismiss()
        onDismissedViewController[viewController] = nil
    }

    public func dismiss(animated: Bool) {
        performOnDismissed(for: navigationController.viewControllers.first!)
        parentViewController.dismiss(animated: animated,
                                     completion: nil)
    }


}

extension ModalNavigationRouter: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(dismissViewController) else {
                return
        }
        performOnDismissed(for: dismissViewController)
    }
}
