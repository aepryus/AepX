//
//  Launch.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Launch: Anchor {
	@objc dynamic var apiid: String = ""
	@objc dynamic var name: String = ""
	@objc dynamic var flightNo: Int = 0
	@objc dynamic var date: Date = Date.now
	@objc dynamic var noOfCrew: Int = 0
	@objc dynamic var details: String? = nil
	@objc dynamic var completed: Bool = false
	@objc dynamic var successful: Bool = false
	@objc dynamic var youtubeID: String? = nil
	@objc dynamic var webcast: String? = nil
	@objc dynamic var patch: String? = nil
	@objc dynamic var wikipedia: String? = nil
	@objc dynamic var launchCores: [LaunchCore] = []
	@objc dynamic var resultString: String = ""

	var result: Result {
		set { resultString = newValue.toString() }
		get { Result.from(string: resultString) ?? .planned }
	}

	var relativeDateComponents: DateComponents {
		Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: date)
	}
	var hasVideo: Bool {  youtubeID != nil && date.timeIntervalSince(Date.now) < 3600 }
	var hasDetails: Bool { (details?.count ?? 0) > 0 }

	var hasCores: Bool { launchCores.count > 0 }
	var hasExpendedCores: Bool {
		guard successful else { return false }
		return launchCores.first(where: { $0.result == .expended }) != nil
	}
	var hasLandedCores: Bool {
		guard successful else { return false }
		return launchCores.first(where: { $0.result == .landed }) != nil
	}
	var hasLostCores: Bool {
		guard successful else { return false }
		return launchCores.first(where: { $0.result == .lost }) != nil
	}

	var rocket: Rocket {
		let core: Core
		if launchCores.count > 0 {
			core = Loom.selectBy(only: launchCores[0].apiid)!
		} else {
			let cores: [Core] = Loom.selectAll()
			core = cores.first { (core: Core) in
				core.launches.contains { $0.apiid == self.apiid }
			} ?? {
				let core = Core()
				core.block = -1
				return core
			}()
		}
		if launchCores.count == 3 {
			return core.version == "Block 5" ? .falconHeavyb5 : .falconHeavy
		} else {
			if core.block == -1 { return .falcon9b5 }
			if core.booster == .falcon1 { return .falcon1 }
			else if core.version == "v1.0" { return .falcon9v10 }

			let hasCrew: Bool = noOfCrew > 0 || name.contains("Crew") || name.contains("CCtCap")
			let hasLegs: Bool = launchCores.count > 0 ? launchCores[0].result != .expended : false

			if core.version == "v1.1" {
				if hasCrew { return .falcon9v11Dragon }
				if hasLegs { return .falcon9v11 }
				return .falcon9v11NoLegs
			}
			if core.version == "FT" || core.version == "Block 4" {
				if hasCrew { return .falcon9v12Dragon }
				if hasLegs { return .falcon9v12 }
				return .falcon9v12NoLegs
			}
			if core.version == "Block 5" {
				if hasCrew { return .falcon9b5Dragon }
				if hasLegs { return .falcon9b5 }
				return .falcon9b5NoLegs
			}
		}
		return .falcon9b5
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "name", "flightNo", "youtubeID", "date", "noOfCrew", "details", "completed",
							"successful", "youtubeID", "webcast", "patch", "wikipedia", "launchCores", "resultString"]
	}
}
