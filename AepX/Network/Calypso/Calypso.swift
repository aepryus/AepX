//
//  Calypso.swift
//  AepX
//
//  Created by Joe Charlier on 7/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class Calypso {
    class CoreQ: Codable {
        var apiid: String = ""
        var serial: String = ""
        var block: Int = 0
        var coreStatus: String = ""
        var config: String = ""
        var launchAPIIDs: [String] = []
        var attempts: Int = 0
        var landings: Int = 0
        var disposition: String = ""
        var note: String = ""
    }
    class CoresQ: Codable {
        var cores: [CoreQ] = []
    }
    class LaunchCoreQ: Codable {
        var apiid: String = ""
        var resultString: String = ""
    }
    class LaunchQ: Codable {
        var apiid: String = ""
        var name: String = ""
        var flightNo: Int = 0
        var date: Date = Date.now
        var noOfCrew: Int = 0
        var details: String? = nil
        var completed: Bool = false
        var successful: Bool = false
        var youtubeID: String? = nil
        var webcast: String? = nil
        var patch: String? = nil
        var wikipedia: String? = nil
        var launchCores: [LaunchCoreQ] = []
        var resultString: String = ""
    }
    class LaunchesQ: Codable {
        var launches: [LaunchQ] = []
    }
    
    static let url = "http://137.184.116.194:8931"

    static let iso8601Formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static let iso8601Formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
    static let decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder: Decoder) -> Date in
            let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
            let string: String = try container.decode(String.self)
            if let date: Date = Calypso.iso8601Formatter1.date(from: string) { return date }
            if let date: Date = Calypso.iso8601Formatter2.date(from: string) { return date }
            throw DateError.invalidDate
        })
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

// Private =========================================================================================
    private static func decodableRequest<T: Decodable>(path: String, method: String, params: [String:Any]? = nil, success: @escaping (T)->(), failure: @escaping ()->()) {
        let url: URL = URL(string: "\(Calypso.url)\(path)")!
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        if let params = params { request.httpBody = params.toJSON().data(using: .utf8) }

        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("decodableRequest error:\n\(error!)")
                failure()
                return
            }

            guard let data = data else {
                print("decodableRequest no data returned")
                failure()
                return
            }

            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("\n[ \(path) : \(response.statusCode) ] ===================================================")
                if let headers = request.allHTTPHeaderFields
                    { print("headers ========================\n\(headers.toJSON())\n") }
                if let params = params
                    { print("params =========================\n\(params.toJSON())\n") }
                if let message = String(data: data, encoding: .utf8)
                    { print("message =========================\n\(message)\n") }
                failure()
                return
            }

//            print(String(data: data, encoding: .utf8)!.toArray().toJSON())

            do {
                success(try decoder.decode(T.self, from: data))
            } catch {
                print("\(error)")
                failure()
                
            }
        }
        task.resume()
    }

// Public ==========================================================================================
    static func cores(success: @escaping ([CoreQ])->(), failure: @escaping ()->()) {
        decodableRequest(path: "/cores", method: "GET") { (cores: CoresQ) in
            success(cores.cores)
        } failure: { failure() }
    }
    static func launches(success: @escaping ([LaunchQ])->(), failure: @escaping ()->()) {
        decodableRequest(path: "/launches", method: "GET") { (launches: LaunchesQ) in
            success(launches.launches)
        } failure: { failure() }
    }
}

// Loaders =========================================================================================
extension Calypso.CoreQ {
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

extension Calypso.LaunchQ {
    func load(launch: Launch) {
        launch.apiid = apiid
        launch.name = name
        launch.flightNo = flightNo
        launch.youtubeID = youtubeID
        launch.webcast = webcast
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
            launchCore.result = Result.from(string: resultString) ?? .failed
            return launchCore
        }
        
    }
}
