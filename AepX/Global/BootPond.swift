//
//  BootPool.swift
//  AepX
//
//  Created by Joe Charlier on 5/8/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class BootPond: Pond {
	lazy var ping: Pebble = pebble(name: "Ping") { (complete: @escaping (Bool) -> ()) in
		complete(true)
//		Pequod.ping { complete(true) }
//			failure: { complete(false) }
	}
	lazy var loadLaunches: Pebble = pebble(name: "loadLaunches") { (complete: @escaping (Bool) -> ()) in
		SpaceX.launches { (launches: [LaunchAPI]) in
			launches.forEach { (launchAPI: LaunchAPI) in
				Loom.transact {
					var launch: Launch = Loom.selectBy(only: launchAPI.id) ?? Loom.create()
					launchAPI.load(launch: launch)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var loadCores: Pebble = pebble(name: "loadCores") { (complete: @escaping (Bool) -> ()) in
		SpaceX.cores { (cores: [CoreAPI]) in
			cores.forEach { (coreAPI: CoreAPI) in
				Loom.transact {
					var core: Core = Loom.selectBy(only: coreAPI.id) ?? Loom.create()
					coreAPI.load(core: core)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var print: Pebble = pebble(name: "print") { (complete: @escaping (Bool) -> ()) in
		AepX.basket.printCensus()
		AepX.basket.printDocuments()
		complete(true)
	}

// Init ============================================================================================
	override init() {
		 super.init()

		ping.ready = { true }

		loadLaunches.ready = { self.ping.succeeded }
		loadCores.ready = { self.ping.succeeded }

		print.ready = {
			self.loadLaunches.completed
			&& self.loadCores.completed
		}
	}
}
