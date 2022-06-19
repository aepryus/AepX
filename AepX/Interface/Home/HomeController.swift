//
//  HomeController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class HomeController: BoosterViewDelegate {
	let vc: HomeViewController

	init(vc: HomeViewController) {
		self.vc = vc
	}

// BoosterViewDelegate =============================================================================
	func onBoosterTapped(core: Core) {
		let rvc = RocketViewController(core: core)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
