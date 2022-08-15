//
//  Calypso.swift
//  AepX
//
//  Created by Joe Charlier on 7/15/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

enum DateError: String, Error {
    case invalidDate
}

class Calypso {
    static let url = "https://aepry.us/calypso"

    static let iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter()

    static let decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder: Decoder) -> Date in
            let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
            let string: String = try container.decode(String.self)
            if let date: Date = Calypso.iso8601Formatter.date(from: string) { return date }
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
    static func cores(success: @escaping ([CalypsoData.Core])->(), failure: @escaping ()->()) {
        decodableRequest(path: "/cores", method: "GET") { (cores: CalypsoData.Cores) in
            success(cores.cores)
        } failure: { failure() }
    }
    static func launches(success: @escaping ([CalypsoData.Launch])->(), failure: @escaping ()->()) {
        decodableRequest(path: "/launches", method: "GET") { (launches: CalypsoData.Launches) in
            success(launches.launches)
        } failure: { failure() }
    }
}

