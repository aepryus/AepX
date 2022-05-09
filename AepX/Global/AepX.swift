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
	static let wakePond: Pond = WakePond()

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
