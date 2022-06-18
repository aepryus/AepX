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
	var wikipedia: String?
}

class CoreAPI: Codable {
	var id: String
	var block: Int?
	var status: String
	var serial: String
	var lastUpdate: String?
	var reuseCount: Int
	var asdsAttempts: Int
	var asdsLandings: Int
	var rtlsAttempts: Int
	var rtlsLandings: Int
	var launches: [String] = []
}

class LaunchCoreAPI: Codable {
	var core: String?
	var landingAttempt: Bool?
	var landingSuccess: Bool?
	var landingType: String?
}

class LaunchCrewAPI: Codable {
	var crew: String?
	var role: String?
}

class LaunchAPI: Codable {
	var id: String
	var name: String
	var flightNumber: Int
	var links: LinksAPI?
	var dateUtc: Date
	var details: String?
	var cores: [LaunchCoreAPI]
	var crew: [LaunchCrewAPI]
	var success: Bool?
}

// Loaders =========================================================================================
extension CoreAPI {
	func load(core: Core) {
		core.apiid = id
		core.serial = serial
		core.block = block ?? 0
		core.coreStatus = status
		core.launchAPIIDs = launches
		core.attempts = asdsAttempts + rtlsAttempts
		core.landings = asdsLandings + rtlsLandings
		if status == "active" {
			core.disposition = "active"
		} else if status == "inactive" {
			core.disposition = "retired"
		} else {
			core.disposition = "destroyed"
		}
		core.note = lastUpdate ?? ""
	}
}

extension LaunchAPI {
	func load(launch: Launch) {
		launch.apiid = id
		launch.name = name
		launch.flightNo = flightNumber
		launch.youtubeID = links?.youtubeId
		launch.webcast = links?.webcast
		launch.patch = links?.patch?.small
		launch.noOfCrew = crew.count
		launch.date = dateUtc
		launch.details = details
		launch.wikipedia = links?.wikipedia
		launch.completed = success != nil
		launch.successful = success ?? false

		launch.launchCores = cores.compactMap {
			guard let appid = $0.core else { return nil }
			let launchCore: LaunchCore = LaunchCore()
			launchCore.apiid = appid

			if !launch.completed { launchCore.result = .planned }
			else if !launch.successful { launchCore.result = .failed }
			else if $0.landingType != "Ocean" && ($0.landingAttempt ?? false) {
				if $0.landingSuccess ?? false { launchCore.result = .landed }
				else { launchCore.result = .lost }
			} else { launchCore.result = .expended }

			return launchCore
		}

		if !launch.completed { launch.result = .planned }
		else if !launch.successful { launch.result = .failed }
		else if launch.hasLostCores && launch.hasLandedCores { launch.result = .partial }
		else if launch.hasLostCores { launch.result = .lost }
		else if launch.hasLandedCores { launch.result = .landed }
		else { launch.result = .expended }

	}
}
