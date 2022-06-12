//
//  Core.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

enum Booster {
	case falcon1, falcon9

	var generation: Int {
		return self == .falcon1 ? 1 : 2
	}
	var name: String {
		switch self {
			case .falcon1: return "Falcon 1"
			case .falcon9: return "Falcon 9"
		}
	}
}

enum Rocket {
	case falcon1
	case falcon9v10
	case falcon9v11Dragon, falcon9v11, falcon9v11NoLegs
	case falcon9v12Dragon, falcon9v12, falcon9v12NoLegs
	case falcon9b5Dragon, falcon9b5, falcon9b5NoLegs
	case falconHeavy, falconHeavyb5

	var height: Double {
		let height: Double
		switch self {
			case .falcon1:
				height = 59.6
			case .falcon9v10:
				height = 142.9
			case .falcon9v11Dragon:
				height = 185
			case .falcon9v11, .falcon9v11NoLegs:
				height = 203.4
			case .falcon9v12Dragon:
				height = 190.7
			case .falcon9b5Dragon:
				height = 192.8
			default:
				height = 208.4
		}
		return height/208.4
	}

	var isFalcon1: Bool {
		switch self {
			case .falcon1:
				return true
			default:
				return false
		}
	}
	var isFalcon9: Bool {
		switch self {
			case .falcon9v10, .falcon9v11, .falcon9v12, .falcon9b5, .falcon9v11Dragon, .falcon9v12Dragon, .falcon9b5Dragon, .falcon9v11NoLegs, .falcon9v12NoLegs, .falcon9b5NoLegs:
				return true
			default:
				return false
		}
	}
	var isFalconHeavy: Bool {
		switch self {
			case .falconHeavy, .falconHeavyb5:
				return true
			default:
				return false
		}
	}

	var image: UIImage {
		switch self {
			case .falcon1:			return UIImage(named: "Falcon1")!
			case .falcon9v10:		return UIImage(named: "Falcon9v10")!
			case .falcon9v11Dragon:	return UIImage(named: "Falcon9v11Dragon")!
			case .falcon9v11:		return UIImage(named: "Falcon9v11")!
			case .falcon9v11NoLegs:	return UIImage(named: "Falcon9v11NoLegs")!
			case .falcon9v12Dragon:	return UIImage(named: "Falcon9v12Dragon")!
			case .falcon9v12:		return UIImage(named: "Falcon9v12")!
			case .falcon9v12NoLegs:	return UIImage(named: "Falcon9v12NoLegs")!
			case .falcon9b5Dragon:	return UIImage(named: "Falcon9b5Dragon")!
			case .falcon9b5:		return UIImage(named: "Falcon9b5")!
			case .falcon9b5NoLegs:	return UIImage(named: "Falcon9b5NoLegs")!
			case .falconHeavy:		return UIImage(named: "FalconHeavy")!
			case .falconHeavyb5:	return UIImage(named: "FalconHeavyb5")!
		}
	}
}

class Core: Anchor {
	@objc dynamic var apiid: String = ""
	@objc dynamic var serial: String = ""
	@objc dynamic var block: Int = 0
	@objc dynamic var coreStatus: String = ""
	@objc dynamic var config: String = ""
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

	var state: String {
		if disposition == "active" { return "active" }

		guard let launch = launches.first,
			  let launchCore = launch.cores.first(where: { $0.apiid == self.apiid })
			else { return "QQQ" }

		if !launch.successful { return "destroyed" }
		if !launchCore.landingAttempt { return "expended" }
		if !launchCore.landingSuccess { return "lost" }

		if disposition == "retired" { return "retired" }

		return "oops"
	}
	var reason: String {
		guard disposition == "destroyed" else { return "" }
		if launches.first(where: { $0.successful == false }) != nil {
			return "on launch"
		} else if launches.first(where: { (launch: Launch) in
			launch.cores.first { (launchCore: LaunchCore) in
				launchCore.apiid == self.apiid && launchCore.landingAttempt && !launchCore.landingSuccess
			} != nil
		}) != nil {
			return "on landing"
		} else {
			return "expended"
		}
	}

	var lastResult: Launch.Result {
		guard let lastLaunch = launches.first else { return .planned }
		return lastLaunch.result
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "serial", "block", "coreStatus", "config", "launchAPIIDs", "attempts", "landings", "disposition", "note"]
	}
}
