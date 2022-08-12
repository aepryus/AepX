//
//  LaunchesController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import UIKit

class LaunchesController: BoosterViewDelegate {
	let vc: LaunchesViewController

	init(vc: LaunchesViewController) {
		self.vc = vc
	}
    
    func loadData() {
        let launches: [Launch] = Loom.selectAll().sorted(by: { (a: Launch, b: Launch) in
            return a.flightNo > b.flightNo
        }).filter {
            if vc.filter.rocketsView.selectedRow(inComponent: 0) != 0 {
                if $0.rocket.isFalcon1 && vc.filter.rocketsView.selectedRow(inComponent: 0) != 1 { return false }
                if $0.rocket.isFalcon9 && vc.filter.rocketsView.selectedRow(inComponent: 0) != 2 { return false }
                if $0.rocket.isFalconHeavy && vc.filter.rocketsView.selectedRow(inComponent: 0) != 3 { return false }
            }

            if vc.filter.missionsView.selectedRow(inComponent: 0) != 0 {
                if vc.filter.missionsView.selectedRow(inComponent: 0) == 1 { return !$0.completed }
                if vc.filter.missionsView.selectedRow(inComponent: 0) == 3 { return $0.completed && !$0.successful }
                if vc.filter.missionsView.selectedRow(inComponent: 0) == 2 && (!$0.completed || !$0.successful) { return false }
            }

            if vc.filter.landingsView.selectedRow(inComponent: 0) != 0 {
                if vc.filter.landingsView.selectedRow(inComponent: 0) == 1 && !$0.hasLandedCores { return false }
                if vc.filter.landingsView.selectedRow(inComponent: 0) == 2 && !$0.hasLostCores { return false }
                if vc.filter.landingsView.selectedRow(inComponent: 0) == 3 && !$0.hasExpendedCores { return false }
            }

            return true
        }

        vc.planned = launches.filter { !$0.completed }
        vc.completed = launches.filter { $0.completed }

        DispatchQueue.main.async {
            self.vc.tableView.reloadData()
        }
    }

// Events ==========================================================================================
	@objc func onFilterTapped() {
		vc.toggleFilter()
	}

// BoosterViewDelegate =============================================================================
	func onBoosterTapped(core: Core) {
		let rvc = RocketViewController(core: core)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
