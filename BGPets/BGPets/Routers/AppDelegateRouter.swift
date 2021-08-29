//
//  AppDelegateRouter.swift
//  BGPets
//
//  Created by bhavesh on 29/08/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import UIKit

public class AppDelegateRouter: Router {

    public let window: UIWindow

    public init(window: UIWindow){
        self.window = window
    }

    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    public func dismiss(animated: Bool) {
        
    }


}
