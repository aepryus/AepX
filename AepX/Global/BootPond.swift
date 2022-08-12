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
        Calypso.launches { (launches: [Calypso.Launch]) in
			launches.forEach { (launchAPI: Calypso.Launch) in
				Loom.transact {
					var launch: Launch = Loom.selectBy(only: launchAPI.apiid) ?? Loom.create()
                    launchAPI.load(launch: launch)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var loadCores: Pebble = pebble(name: "loadCores") { (complete: @escaping (Bool) -> ()) in
        Calypso.cores { (cores: [Calypso.Core]) in
			cores.forEach { (coreAPI: Calypso.Core) in
				Loom.transact {
					var core: Core = Loom.selectBy(only: coreAPI.apiid) ?? Loom.create()
                    coreAPI.load(core: core)
				}
			}
			complete(true)
		} failure: {
			complete(false)
		}
	}
	lazy var refreshScreens: Pebble = pebble(name: "refreshScreens") { (complete: @escaping (Bool) -> ()) in
        (AepX.window.rootViewController as! RootViewController).homeViewController.controller.loadData()
        (AepX.window.rootViewController as! RootViewController).launchesViewController.controller.loadData()
        (AepX.window.rootViewController as! RootViewController).rocketsViewController.controller.loadData()
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
