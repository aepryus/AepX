//
//  LaunchController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class LaunchController {
	let vc: LaunchViewController

	init(vc: LaunchViewController) {
		self.vc = vc
	}

	func load(id: String) {
		SpaceX.launch(id: id) { (launch: Launch) in
			DispatchQueue.main.async {
				self.vc.launch = launch
			}
		} failure: { print("failure") }
	}
}
