//
//  LaunchesController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class LaunchesController: LaunchCellDelegate {
	let vc: LaunchesViewController

	init(vc: LaunchesViewController) {
		self.vc = vc
	}

// Events ==========================================================================================
	func onLaunchCellTapped(launch: Launch) {
		let rvc = LaunchViewController(launch: launch)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
