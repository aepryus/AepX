//
//  SpaceXLoaders.swift
//  AepX
//
//  Created by Joe Charlier on 5/8/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class PatchAPI: Codable {
	var small: String?
	var large: String?
}

class LinksAPI: Codable {
	var patch: PatchAPI?
	var webcast: String?
	var youtubeId: String?
}

class CoreAPI: Codable {
	var id: String = ""
	var block: Int? = nil
	var status: String = ""
	var serial: String = ""
	var lastUpdate: String? = nil
	var reuseCount: Int = 0

	var asdsAttempts: Int = 0
	var asdsLandings: Int = 0
	var rtlsAttempts: Int = 0
	var rtlsLandings: Int = 0

	var launches: [String] = []

	func load(core: Core) {
		core.apiid = id
		core.serial = serial
		core.block = block ?? 0
		core.coreStatus = status
		core.launchAPIIDs = launches
	}
}

class LaunchAPI: Codable {
	var id: String
	var name: String
	var flightNumber: Int
	var links: LinksAPI?
	var dateUtc: Date

	var relative: String {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.allowedUnits = [.second, .minute, .hour, .day]
		return formatter.string(from: Date.now, to: dateUtc)!
	}

	func load(launch: Launch) {
		launch.apiid = id
		launch.name = name
		launch.flightNo = flightNumber
		launch.youtubeID = links?.youtubeId
		launch.webcast = links?.webcast
		launch.patch = links?.patch?.small
		launch.date = dateUtc
	}
}
