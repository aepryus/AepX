//
//  Launch.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

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
	@objc dynamic var cores: [LaunchCore] = []

	var relative: String {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.allowedUnits = [.second, .minute, .hour, .day]
		return formatter.string(from: Date.now, to: date)!
	}
	var relativeDateComponents: DateComponents {
		Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: date)
	}

	var rocket: Rocket {
		let core: Core
		if cores.count > 0 {
			core = Loom.selectBy(only: cores[0].appid)!
		} else {
			let cores: [Core] = Loom.selectAll()
			core = cores.first { (core: Core) in
				core.launches.contains { $0.apiid == self.apiid }
			} ?? Core()
		}
		if cores.count == 3 {
			return core.block == 5 ? .falconHeavyb5 : .falconHeavy
		} else {
			if core.block == 0 { return .falcon1 }
			else if core.serial[1] == "0" { return .falcon9v10 }

			let hasCrew: Bool = noOfCrew > 0 || name.contains("Crew")
			let hasLegs: Bool = cores.count > 0 ? cores[0].landingAttempt : false

			if core.block <= 3 {
				if hasCrew { return .falcon9v11Dragon }
				if hasLegs { return .falcon9v11 }
				return .falcon9v11NoLegs
			}
			if core.block <= 4 {
				if hasCrew { return .falcon9v12Dragon }
				if hasLegs { return .falcon9v12 }
				return .falcon9v12NoLegs
			}
			if core.block == 5 {
				if hasCrew { return .falcon9b5Dragon }
				if hasLegs { return .falcon9b5 }
				return .falcon9b5NoLegs
			}
		}
		return .falconHeavyb5
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "name", "flightNo", "youtubeID", "date", "noOfCrew", "details", "completed",
							"successful", "youtubeID", "webcast", "patch", "wikipedia", "cores"]
	}
}
