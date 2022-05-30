//
//  StatsFace.swift
//  AepX
//
//  Created by Joe Charlier on 5/5/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class StatsFace: Face {
	let titleLabel: UILabel = UILabel()
	let launchesLabel: UILabel = UILabel()
	let launchesValue: UILabel = UILabel()
	let landingsLabel: UILabel = UILabel()
	let landingsValue: UILabel = UILabel()
	let reflightsLabel: UILabel = UILabel()
	let reflightsValue: UILabel = UILabel()

	let titlePen: Pen = Pen(font: UIFont(name: "AvenirNext-DemiBold", size: 23*Screen.s)!, color: .white)
	let labelPen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 19*Screen.s)!, color: .white, alignment: .right)
	let valuePen: Pen = Pen(font: UIFont(name: "AvenirNext-Heavy", size: 19*Screen.s)!, color: .white, alignment: .left)

	init() {
		super.init(frame: .zero)

		titleLabel.text = "Statistics".localized
		titleLabel.pen = titlePen
		addSubview(titleLabel)

		launchesLabel.text = "Launches: ".localized
		launchesLabel.pen = labelPen
		addSubview(launchesLabel)

		launchesValue.pen = valuePen
		addSubview(launchesValue)

		landingsLabel.text = "Landings: ".localized
		landingsLabel.pen = labelPen
		addSubview(landingsLabel)

		landingsValue.pen = valuePen
		addSubview(landingsValue)

		reflightsLabel.text = "Reflights: ".localized
		reflightsLabel.pen = labelPen
		addSubview(reflightsLabel)

		reflightsValue.pen = valuePen
		addSubview(reflightsValue)

		loadData()
	}
	required init?(coder: NSCoder) { fatalError() }

	func loadData() {
		let launches: [Launch] = Loom.selectAll().sorted { (a: Launch, b: Launch) in
			return a.flightNo < b.flightNo
		}
		let cores: [Core] = Loom.selectAll()

		launchesValue.text = "\(launches.summate { $0.successful ? 1 : 0 }) of \(launches.summate { $0.completed ? 1 : 0 })"
		landingsValue.text = "\(launches.summate { $0.cores.summate{ $0.landingSuccess ? 1 : 0 } }) of \(launches.summate { $0.successful ? $0.cores.summate{ $0.landingAttempt ? 1 : 0 } : 0 })"
		reflightsValue.text = "\(cores.summate { $0.launches.count > 1 ? $0.launches.count-1 : 0 })"

		var launchLandings: [String:Int] = [:]
		var coreLandings: [String:Int] = [:]

		cores.forEach {
			launchLandings[$0.apiid] = 0
			coreLandings[$0.apiid] = 0
		}

		launches.forEach { (launch: Launch) in
			launch.cores.forEach { (launchCore: LaunchCore) in
				guard launchCore.landingSuccess else { return }
				launchLandings[launchCore.apiid] = launchLandings[launchCore.apiid]! + 1
			}
		}

		cores.forEach { (core: Core) in
			coreLandings[core.apiid] = coreLandings[core.apiid]! + core.landings
		}

		launchLandings.keys.forEach {
			if launchLandings[$0] != coreLandings[$0] {
				let core: Core = Loom.selectBy(only: $0)!
				print("])> \(core.serial): [\(launchLandings[$0]!)][\(coreLandings[$0]!)]")
			}
		}

	}

// Face ============================================================================================
	override var faceHeight: CGFloat { 150*s }

// UIView ==========================================================================================
	override func layoutSubviews() {
		let p: CGFloat = 48*s
		titleLabel.topLeft(dx: 12*s, dy: 10*s, width: 300*s, height: 30*s)
		launchesLabel.topLeft(dx: p, dy: titleLabel.bottom+4*s, width: 120*s, height: 30*s)
		launchesValue.topLeft(dx: launchesLabel.right+5*s, dy: launchesLabel.top, width: 120*s, height: 30*s)
		landingsLabel.topLeft(dx: p, dy: launchesLabel.bottom, width: 120*s, height: 30*s)
		landingsValue.topLeft(dx: landingsLabel.right+5*s, dy: landingsLabel.top, width: 120*s, height: 30*s)
		reflightsLabel.topLeft(dx: p, dy: landingsLabel.bottom, width: 120*s, height: 30*s)
		reflightsValue.topLeft(dx: reflightsLabel.right+5*s, dy: reflightsLabel.top, width: 120*s, height: 30*s)
	}
}
