//
//  Launch.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class Patch: Codable {
	var small: String?
	var large: String?
}

class Links: Codable {
	var patch: Patch?
	var webcast: String?
	var youtubeId: String?
}

class Launch: Codable {
	var id: String
	var name: String
	var flightNumber: Int
	var links: Links?
	var dateUtc: Date

	var relative: String {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.allowedUnits = [.second, .minute, .hour, .day]
		return formatter.string(from: Date.now, to: dateUtc)!
	}
}
