//
//  WakePond.swift
//  AepX
//
//  Created by Joe Charlier on 5/8/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class WakePond: Pond {
	lazy var ping: Pebble = pebble(name: "Ping") { (complete: @escaping (Bool) -> ()) in
		complete(true)
	}

// Init ============================================================================================
	override init() {
		 super.init()

		ping.ready = { true }
	}
}
