//
//  RocketsController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class RocketsController: RocketCellDelegate {
	let vc: RocketsViewController

	init(vc: RocketsViewController) {
		self.vc = vc
	}

    func loadData() {
        vc.activeCores = []
        vc.inactiveCores = []

        let cores: [Core] = Loom.selectAll().filter { (core: Core) in
            var result: Bool = true
            switch vc.filter.statesView.selectedRow(inComponent: 0) {
                case 1: if core.state != "active" { result = false }
                case 2: if core.state != "pending" { result = false }
                case 3: if core.state != "retired" { result = false }
                case 4: if core.state != "expended" { result = false }
                case 5: if core.state != "lost" && core.state != "oops" { result = false }
                case 6: if core.state != "destroyed" { result = false }
                default: break
            }
            switch vc.filter.shipsView.selectedRow(inComponent: 0) {
                case 1: if !(core.booster == .falcon9 && core.version == "block 5") { result = false }
                case 2: if !(core.booster == .falcon9 && core.version == "block 4") { result = false }
                case 3: if !(core.booster == .falcon9 && core.version == "FT") { result = false }
                case 4: if !(core.booster == .falcon9 && core.version == "v1.1") { result = false }
                case 5: if !(core.booster == .falcon9 && core.version == "v1.0") { result = false }
                case 6: if !(core.booster == .falcon1) { result = false }
                default: break
            }
            return result
        }

        if vc.filter.sortsView.selectedRow(inComponent: 0) == 0 {
            cores.forEach {
                if $0.coreStatus == "active" { vc.activeCores.append($0) }
                else { vc.inactiveCores.append($0) }
            }
            vc.activeCores.sort(by: { (a: Core, b: Core) in
                if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
                return a.serial < b.serial
            })
            vc.inactiveCores.sort(by: { (a: Core, b: Core) in
                if a.launches.count != b.launches.count { return a.launches.count > b.launches.count }
                if let aLast = a.launches.last, let bLast = b.launches.last {
                    return aLast.date > bLast.date
                }
                return a.serial < b.serial
            })
        } else {
            vc.activeCores = cores
            vc.activeCores.sort(by:  { (a: Core, b: Core) in
                if a.booster.generation == b.booster.generation { return a.serial > b.serial }
                return a.booster.generation > b.booster.generation
            })
        }

        vc.tableView.reloadData()
    }

// RocketCellDelegate ==============================================================================
	func onRocketCellTapped(core: Core) {
		let rvc = RocketViewController(core: core)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
	@objc func onFilterTapped() {
		vc.toggleFilter()
	}
}
