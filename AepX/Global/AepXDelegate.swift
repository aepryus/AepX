//
//  AppDelegate.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

@main
class AepXDelegate: UIResponder, UIApplicationDelegate {
// UIApplicationDelegate ===========================================================================
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		AepX.start()
		return true
	}
	func applicationWillEnterForeground(_ application: UIApplication) {
		if AepX.wakePond.complete { AepX.wakePond.reset() }
		if !AepX.wakePond.started { AepX.wakePond.start() }
	}
}
