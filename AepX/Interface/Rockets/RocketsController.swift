//
//  RocketsController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class RocketsController: RocketCellDelegate {
	let vc: RocketsViewController

	init(vc: RocketsViewController) {
		self.vc = vc
	}

// RocketCellDelegate ==============================================================================
	func onRocketCellTapped(core: Core) {
		let rvc = RocketViewController(core: core)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
