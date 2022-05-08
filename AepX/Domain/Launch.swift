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
	@objc dynamic var youtubeID: String? = nil
	@objc dynamic var webcast: String? = nil
	@objc dynamic var patch: String? = nil
	@objc dynamic var date: Date = Date.now

	var relative: String {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.allowedUnits = [.second, .minute, .hour, .day]
		return formatter.string(from: Date.now, to: date)!
	}
	var relativeDateComponents: DateComponents {
		Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date.now, to: date)
	}

// Domain ==========================================================================================
	override var properties: [String] {
		super.properties + ["apiid", "name", "flightNo", "youtubeID", "webcast", "patch", "date"]
	}
}
