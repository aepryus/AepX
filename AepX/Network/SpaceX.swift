//
//  SpaceX.swift
//  AepX
//
//  Created by Joe Charlier on 4/29/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

enum DateError: String, Error {
	case invalidDate
}

class SpaceX {
	static let url = "https://api.spacexdata.com"
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
			if let date: Date = SpaceX.iso8601Formatter1.date(from: string) { return date }
			if let date: Date = SpaceX.iso8601Formatter2.date(from: string) { return date }
			throw DateError.invalidDate
		})
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()

// Private =========================================================================================
	private static func decodableRequest<T: Decodable>(path: String, method: String, params: [String:Any]? = nil, success: @escaping (T)->(), failure: @escaping ()->()) {
		let url: URL = URL(string: "\(SpaceX.url)\(path)")!
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
				if let headers = request.allHTTPHeaderFields { print("headers ========================\n\(headers.toJSON())\n") }
				if let params = params { print("params =========================\n\(params.toJSON())\n") }
				if let message = String(data: data, encoding: .utf8) { print("message =========================\n\(message)\n") }
				failure()
				return
			}

//			let json = String(data: data, encoding: .utf8)!
//			let attributes = json.toArray()
//			print(attributes.toJSON())

			do {
				let result: T = try decoder.decode(T.self, from: data)
				success(result)
			} catch { failure() }
		}
		task.resume()
	}

// Public ==========================================================================================
	static func cores(success: @escaping ([CoreAPI])->(), failure: @escaping ()->()) {
		decodableRequest(path: "/v4/cores", method: "GET") { (cores: [CoreAPI]) in
			success(cores)
		} failure: { failure() }
	}
	static func launches(success: @escaping ([LaunchAPI])->(), failure: @escaping ()->()) {
		decodableRequest(path: "/v5/launches", method: "GET") { (launches: [LaunchAPI]) in
			success(launches)
		} failure: { failure() }
	}
}
