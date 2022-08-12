//
//  HomeController.swift
//  AepX
//
//  Created by Joe Charlier on 5/1/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation

class HomeController: BoosterViewDelegate {
	let vc: HomeViewController

	init(vc: HomeViewController) {
		self.vc = vc
	}
    
    func loadData() {
        let launches: [Launch] = Loom.selectAll().sorted { (a: Launch, b: Launch) in
            return a.flightNo > b.flightNo
        }
        guard launches.count > 2 else { return }
        var i: Int = 0
        while i < launches.count-1 {
            if !launches[i].completed && launches[i+1].completed {
                break
            }
            i += 1
        }

        vc.latestFace.load(controller: self, launch: launches[i+1])
        vc.nextFace.load(controller: self, launch: launches[i])
        
        vc.statsFace.loadData(launches: launches.reversed(), cores: Loom.selectAll())
        vc.yearsFace.loadData(launches: launches.filter { $0.completed })
        vc.tableView.reloadData()
    }

// BoosterViewDelegate =============================================================================
	func onBoosterTapped(core: Core) {
		let rvc = RocketViewController(core: core)
		vc.navigationController?.pushViewController(rvc, animated: true)
	}
}
