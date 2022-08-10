//
//  Core.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Core: Anchor {
	@objc dynamic var apiid: String = ""
	@objc dynamic var serial: String = ""
	@objc dynamic var block: Int = 0
	@objc dynamic var coreStatus: String = ""
	@objc dynamic var launchAPIIDs: [String] = []
	@objc dynamic var attempts: Int = 0
	@objc dynamic var landings: Int = 0
	@objc dynamic var disposition: String = ""
	@objc dynamic var note: String = ""

	var booster: Booster {
		if block == 0 { return .falcon1 }
		else { return .falcon9 }
	}
	var version: String {
		if booster == .falcon1 { return "" }
		else if booster == .falcon9 {
			if serial[1] == "0" { return "v1.0" }
			else if ["B1019", "B1020"].contains(serial) { return "FT" }
			else {
				switch block {
					case 1: return "v1.1"
					case 2: return "FT"
					case 3: return "FT"
					case 4: return "block 4"
					case 5: return "block 5"
					default: return  ""
				}
			}
		}
		return ""
	}
	var name: String { booster.name + version }

	var launches: [Launch] {
		launchAPIIDs.map { Loom.selectBy(only: $0)! }.sorted { (a: Launch, b: Launch) in
			return a.date > b.date
		}
	}
	var lastLaunch: Launch? { launches.first }
	var lastResult: Result {
		guard let lastLaunch = launches.first else { return .planned }
		return lastLaunch.result
	}

	var state: String {
		if disposition == "active" { return "active" }

		guard let lastLaunch: Launch = lastLaunch,
			  let launchCore: LaunchCore = lastLaunch.launchCores.first(where: { $0.apiid == self.apiid })
			else { return "unknown" }

		switch launchCore.result {
			case .expended:	return "expended"
			case .lost:		return "lost"
			case .failed:	return "destroyed"
			default:		break
		}

		if disposition == "retired" { return "retired" }

		return "oops"
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "serial", "block", "coreStatus", "launchAPIIDs", "attempts", "landings", "disposition", "note"]
	}
}
