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
	lazy var refreshScreens: Pebble = pebble(name: "refreshScreens") { (complete: @escaping (Bool) -> ()) in
		(AepX.window.rootViewController as! RootViewController).homeViewController.loadData()
		(AepX.window.rootViewController as! RootViewController).launchesViewController.loadData()
		(AepX.window.rootViewController as! RootViewController).rocketsViewController.loadData()
		complete(true)
	}

// Init ============================================================================================
	override init() {
		 super.init()

		loadLaunches.ready = { true }
		loadCores.ready = { true }

		refreshScreens.ready = {
			self.loadLaunches.completed
			&& self.loadCores.completed
		}
	}
}
