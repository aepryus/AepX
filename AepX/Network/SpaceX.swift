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

// Private =========================================================================================
	private static func attributesRequest(path: String, method: String, params: [String:Any]? = nil, success: @escaping ([String:Any])->(), failure: @escaping ()->()) {
		let url: URL = URL(string: "\(SpaceX.url)\(path)")!
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = method

		if let params = params {
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = params.toJSON().data(using: .utf8)
		}

		let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			guard error == nil else {
				print("error: \(error!)")
				failure();return
			}

			guard let data = data else { failure();return }

			if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
				print("\n[ \(path) : \(response.statusCode) ] ===================================================")
				if let headers = request.allHTTPHeaderFields { print("headers ========================\n\(headers.toJSON())\n") }
				if let params = params { print("params =========================\n\(params.toJSON())\n") }
				if let message = String(data: data, encoding: .utf8) { print("message =========================\n\(message)\n") }
				failure();return
			}

			if let result = String(data: data, encoding: .utf8) {
				success(result.toAttributes())
			} else {
				failure()
			}
		}
		task.resume()
	}
	private static func decodableRequest<T: Decodable>(path: String, method: String, params: [String:Any]? = nil, success: @escaping (T)->(), failure: @escaping ()->()) {
		let url: URL = URL(string: "\(SpaceX.url)\(path)")!
		var request: URLRequest = URLRequest(url: url)
		request.httpMethod = method

		if let params = params {
			request.httpBody = params.toJSON().data(using: .utf8)
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")
		}

		let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
			guard error == nil else {
				print("error: \(error!)")
				failure();return
			}

			guard let data = data else { failure();return }

			if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
				print("\n[ \(path) : \(response.statusCode) ] ===================================================")
				if let headers = request.allHTTPHeaderFields { print("headers ========================\n\(headers.toJSON())\n") }
				if let params = params { print("params =========================\n\(params.toJSON())\n") }
				if let message = String(data: data, encoding: .utf8) { print("message =========================\n\(message)\n") }
				failure();return
			}

			let decoder = JSONDecoder()
			let formatter = DateFormatter()
			formatter.calendar = Calendar(identifier: .iso8601)
			formatter.locale = Locale(identifier: "en_US_POSIX")
			formatter.timeZone = TimeZone(secondsFromGMT: 0)

			decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
				let container = try decoder.singleValueContainer()
				let dateStr = try container.decode(String.self)

				formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
				if let date = formatter.date(from: dateStr) {
					return date
				}
				formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
				if let date = formatter.date(from: dateStr) {
					return date
				}
				throw DateError.invalidDate
			})
			decoder.keyDecodingStrategy = .convertFromSnakeCase

//			let json = String(data: data, encoding: .utf8)!
//			let attributes = json.toArray()
//			print(attributes.toJSON())

			let result: T = try! decoder.decode(T.self, from: data)
			success(result)
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
