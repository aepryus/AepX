//
//  Core.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

//import Acheron
import Foundation

extension Decodable {
	init?(json: String) throws {
		guard let data = json.data(using: .utf8) else { return nil }
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
		self = try decoder.decode(Self.self, from: data)
	}
}
extension Encodable {
	func toJSON() -> String {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try! encoder.encode(self)
		return String(data: data, encoding: .utf8)!
	}
}

class Core: Codable {
	var id: String = "asd"
	var block: Int? = nil
	var status: String = "asd"
	var serial: String = "asd"
	var lastUpdate: String? = nil
	var reuseCount: Int = 1

	var asdsAttempts: Int = 2
	var asdsLandings: Int = 3
	var rtlsAttempts: Int = 4
	var rtlsLandings: Int = 5

	var launches: [Launch] = []

//	init(json: String) {
//		super.init(from: JSONDecoder())
//	}


// Domain ==========================================================================================
//	override var properties: [String] {
//		return super.properties + ["block", "qstatus", "serial", "id", "last_update", "reuse_count", "asds_attempts", "asds_landings", "rtls_attempts", "rtls_landings"]
//	}
}
