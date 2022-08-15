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
        Calypso.launches { (launches: [CalypsoData.Launch]) in
            Loom.transact {
                let existing: [Launch] = Loom.selectAll()
                existing.forEach { (launch: Launch) in
                    if !launches.contains(where: { $0.apiid == launch.apiid }) {
                        launch.delete()
                    }
                }
                launches.forEach { (launchAPI: CalypsoData.Launch) in
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
        Calypso.cores { (cores: [CalypsoData.Core]) in
            Loom.transact {
                let existing: [Core] = Loom.selectAll()
                existing.forEach { (core: Core) in
                    if !cores.contains(where: { $0.apiid == core.apiid }) {
                        core.delete()
                    }
                }
                cores.forEach { (coreAPI: CalypsoData.Core) in
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
