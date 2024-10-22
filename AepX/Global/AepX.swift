//
//  AepX.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class AepX {
	static let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
	static let basket: Basket = Basket(SQLitePersist("AepX"))
	static let bootPond: Pond = BootPond()

	static var version: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0" }
	static var widthScale: CGFloat { AepX.window.width/(375*Screen.s) }

	static func start() {
		print("[ AepX ] ======================================================================")

		Loom.start(basket: AepX.basket, namespaces: ["AepX"])

		basket.associate(type: "launch", only: "apiid")
		basket.associate(type: "core", only: "apiid")

		window.rootViewController = RootViewController()
		window.makeKeyAndVisible()

		bootPond.start()
	}
}
