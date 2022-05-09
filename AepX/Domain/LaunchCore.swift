//
//  LaunchCore.swift
//  AepX
//
//  Created by Joe Charlier on 5/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class LaunchCore: Domain {
	@objc dynamic var appid: String = ""
	@objc dynamic var landingAttempt: Bool = false
	@objc dynamic var landingSuccess: Bool = false

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["appid", "landingAttempt", "landingSuccess"]
	}
}
