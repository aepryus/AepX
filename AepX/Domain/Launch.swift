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
	enum Result {
		case planned, successLanded, successPartial, successLost, successExpended, failure

		var color: UIColor {
			let tonePercent: CGFloat = 0.6
			switch self {
				case .planned:			return .white.tone(tonePercent)
				case .successLanded:	return .blue.tone(tonePercent)
				case .successPartial:	return .purple.tone(tonePercent)
				case .successLost:		return .orange.tone(tonePercent)
				case .successExpended:	return .cyan.tone(tonePercent)
				case .failure:			return .red.tone(tonePercent)
			}
		}
	}

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
	var hasVideo: Bool {
		return date.timeIntervalSince(Date.now) < 3600 && youtubeID != nil
	}
	var hasDetails: Bool {
		return (details?.count ?? 0) > 0
	}
	var result: Result {
		if !completed { return .planned }
		else if !successful { return .failure }
		else if hasLostCores && hasLandedCores { return .successPartial }
		else if hasLostCores { return .successLost }
		else if hasLandedCores { return .successLanded }
		else { return .successExpended }
	}

	var hasCores: Bool { cores.count > 0 }
	var hasExpendedCores: Bool {
		guard successful else { return false }
		return cores.first(where: { !$0.landingAttempt }) != nil
	}
	var hasLandedCores: Bool {
		guard successful else { return false }
		return cores.first(where: { $0.landingAttempt && $0.landingSuccess }) != nil
	}
	var hasLostCores: Bool {
		guard successful else { return false }
		return cores.first(where: { $0.landingAttempt && !$0.landingSuccess }) != nil
	}

	var rocket: Rocket {
		let core: Core
		if cores.count > 0 {
			core = Loom.selectBy(only: cores[0].apiid)!
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
		if cores.count == 3 {
			return core.block == 5 ? .falconHeavyb5 : .falconHeavy
		} else {
			if core.block == -1 { return .falcon9b5 }
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
