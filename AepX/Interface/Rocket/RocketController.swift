//
//  RocketController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class RocketController: LaunchCellDelegate {
	let vc: RocketViewController

	init(vc: RocketViewController) {
		self.vc = vc
	}

	func load(id: String) {
		SpaceX.core(id: id) { (core: Core) in
			DispatchQueue.main.async {
				self.vc.core = core
				self.vc.tableView.reloadData()
			}
		} failure: { print("failure") }
	}

// RocketCellDelegate ==============================================================================
	func onLaunchCellTapped(launch: Launch) {
//		let rvc = RocketViewController(core: core)
//		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
