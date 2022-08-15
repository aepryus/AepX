//
//  CalypsoData.swift
//  AepX
//
//  Created by Joe Charlier on 8/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class CalypsoData {
    class Core: Codable {
        var apiid: String = ""
        var serial: String = ""
        var block: Int = 0
        var coreStatus: String = ""
        var launchAPIIDs: [String] = []
        var attempts: Int = 0
        var landings: Int = 0
        var disposition: String = ""
        var note: String = ""
    }
    class Cores: Codable {
        var cores: [Core] = []
    }
    class LaunchCore: Codable {
        var apiid: String = ""
        var resultString: String = ""
    }
    class Launch: Codable {
        var apiid: String = ""
        var name: String = ""
        var flightNo: Int = 0
        var date: Date = Date.now
        var noOfCrew: Int = 0
        var details: String? = nil
        var completed: Bool = false
        var successful: Bool = false
        var youtubeID: String? = nil
        var patch: String? = nil
        var wikipedia: String? = nil
        var launchCores: [LaunchCore] = []
        var resultString: String = ""
    }
    class Launches: Codable {
        var launches: [Launch] = []
    }
}

// Loaders =========================================================================================
extension CalypsoData.Core {
    func load(core: Core) {
        core.apiid = apiid
        core.serial = serial
        core.block = block
        core.coreStatus = coreStatus
        core.launchAPIIDs = launchAPIIDs
        core.attempts = attempts
        core.landings = landings
        core.disposition = disposition
        core.note = note
    }
}

extension CalypsoData.Launch {
    func load(launch: Launch) {
        launch.apiid = apiid
        launch.name = name
        launch.flightNo = flightNo
        launch.youtubeID = youtubeID
        launch.patch = patch
        launch.noOfCrew = noOfCrew
        launch.date = date
        launch.details = details
        launch.wikipedia = wikipedia
        launch.completed = completed
        launch.successful = successful
        launch.result = Result.from(string: resultString) ?? .failed

        launch.launchCores = launchCores.compactMap {
            let launchCore: LaunchCore = LaunchCore()
            launchCore.apiid = $0.apiid
            launchCore.result = Result.from(string: $0.resultString) ?? .failed
            return launchCore
        }
    }
}
