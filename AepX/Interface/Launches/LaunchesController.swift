//
//  LaunchesController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import UIKit

class LaunchesController {
	let vc: LaunchesViewController

	init(vc: LaunchesViewController) {
		self.vc = vc
	}

// Events ==========================================================================================
	@objc func onFilterTapped() {
		vc.toggleFilter()
	}
}
