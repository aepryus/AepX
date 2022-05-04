//
//  AepX.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class AepX {
	static let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)

	static func start() {
		print("[ AepX ] ======================================================================")
		window.rootViewController = RootViewController()
		window.makeKeyAndVisible()
	}
}
