//
//  Core.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class Core: Anchor {
	@objc dynamic var apiid: String = ""
	@objc dynamic var serial: String = ""
	@objc dynamic var block: Int = 0
	@objc dynamic var coreStatus: String = ""
	@objc dynamic var config: String = ""
	@objc dynamic var launchAPIIDs: [String] = []
	@objc dynamic var attempts: Int = 0
	@objc dynamic var landings: Int = 0

	var launches: [Launch] {
		launchAPIIDs.map { Loom.selectBy(only: $0)! }
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "serial", "block", "coreStatus", "config", "launchAPIIDs", "attempts", "landings"]
	}
}
