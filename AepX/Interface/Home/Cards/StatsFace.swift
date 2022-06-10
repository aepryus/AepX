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
	let launchesLabel: UILabel = UILabel()
	let landingsLabel: UILabel = UILabel()
	let successLabel: UILabel = UILabel()
	let failureLabel: UILabel = UILabel()
	let totalLabel: UILabel = UILabel()




	let missionsYes: UILabel = UILabel()
	let missionsNo: UILabel = UILabel()
	let missionsAll: UILabel = UILabel()

	let landingsYes: UILabel = UILabel()
	let landingsNo: UILabel = UILabel()
	let landingsAll: UILabel = UILabel()

	let reflightsLabel: UILabel = UILabel()
	let reflightsValue: UILabel = UILabel()

	let humansLabel: UILabel = UILabel()
	let humansValue: UILabel = UILabel()

	let lefterPen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 17*Screen.s)!, color: .white, alignment: .right)
	let headerPen: Pen = Pen(font: UIFont(name: "AvenirNext-Medium", size: 17*Screen.s)!, color: .white, alignment: .right)
	let valuePen: Pen = Pen(font: UIFont(name: "AvenirNext-Heavy", size: 19*Screen.s)!, color: .white, alignment: .right)

	init() {
		super.init(frame: .zero)

		launchesLabel.text = "missions".localized
		launchesLabel.pen = lefterPen
		addSubview(launchesLabel)

		landingsLabel.text = "landings".localized
		landingsLabel.pen = lefterPen
		addSubview(landingsLabel)

		successLabel.text = "success".localized
		successLabel.pen = headerPen
		addSubview(successLabel)

		failureLabel.text = "failure".localized
		failureLabel.pen = headerPen
		addSubview(failureLabel)

		totalLabel.text = "total".localized
		totalLabel.pen = headerPen
		addSubview(totalLabel)

		missionsYes.pen = valuePen
		addSubview(missionsYes)

		missionsNo.pen = valuePen
		addSubview(missionsNo)

		missionsAll.pen = valuePen
		addSubview(missionsAll)

		landingsYes.pen = valuePen
		addSubview(landingsYes)

		landingsNo.pen = valuePen
		addSubview(landingsNo)

		landingsAll.pen = valuePen
		addSubview(landingsAll)

		reflightsLabel.text = "reflights: ".localized
		reflightsLabel.pen = lefterPen
		addSubview(reflightsLabel)

		reflightsValue.pen = valuePen.clone(alignment: .left)
		addSubview(reflightsValue)

		humansLabel.text = "humans: ".localized
		humansLabel.pen = lefterPen
		addSubview(humansLabel)

		humansValue.pen = valuePen.clone(alignment: .left)
		addSubview(humansValue)

		loadData()
	}
	required init?(coder: NSCoder) { fatalError() }

	func loadData() {
		let launches: [Launch] = Loom.selectAll().sorted { (a: Launch, b: Launch) in
			return a.flightNo < b.flightNo
		}
		let cores: [Core] = Loom.selectAll()

		let missionsSuccess = launches.summate { $0.successful ? 1 : 0 }
		let missionsTotal = launches.summate { $0.completed ? 1 : 0 }
		let landingsSuccess = launches.summate { $0.cores.summate{ $0.landingSuccess ? 1 : 0 } }
		let landingsTotal = launches.summate { $0.successful ? $0.cores.summate{ $0.landingAttempt ? 1 : 0 } : 0 }

		missionsYes.text = "\(missionsSuccess)"
		missionsNo.text = "\(missionsTotal - missionsSuccess)"
		missionsAll.text = "\(missionsTotal)"
		landingsYes.text = "\(landingsSuccess)"
		landingsNo.text = "\(landingsTotal - landingsSuccess)"
		landingsAll.text = "\(landingsTotal)"

		reflightsValue.text = "\(cores.summate { $0.launches.count > 1 ? $0.launches.count-1 : 0 })"
		humansValue.text = "\(launches.summate { $0.noOfCrew })"

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
		let cw: CGFloat = 72*s

		successLabel.topLeft(dx: 100*s, dy: 6*s, width: cw, height: 30*s)
		failureLabel.topLeft(dx: successLabel.right, dy: successLabel.top, width: cw, height: 30*s)
		totalLabel.topLeft(dx: failureLabel.right, dy: successLabel.top, width: cw, height: 30*s)
		launchesLabel.topLeft(dx: 0, dy: successLabel.bottom, width: successLabel.left, height: 30*s)
		landingsLabel.topLeft(dx: launchesLabel.left, dy: launchesLabel.bottom, width: launchesLabel.width, height: 30*s)

		missionsYes.topLeft(dx: successLabel.left, dy: launchesLabel.top, width: cw, height: 30*s)
		missionsNo.topLeft(dx: failureLabel.left, dy: launchesLabel.top, width: cw, height: 30*s)
		missionsAll.topLeft(dx: totalLabel.left, dy: launchesLabel.top, width: cw, height: 30*s)
		landingsYes.topLeft(dx: successLabel.left, dy: landingsLabel.top, width: cw, height: 30*s)
		landingsNo.topLeft(dx: failureLabel.left, dy: landingsLabel.top, width: cw, height: 30*s)
		landingsAll.topLeft(dx: totalLabel.left, dy: landingsLabel.top, width: cw, height: 30*s)

		reflightsLabel.topLeft(dx: 18*s, dy: landingsLabel.bottom+6*s, width: 120*s, height: 30*s)
		reflightsValue.topLeft(dx: reflightsLabel.right+5*s, dy: reflightsLabel.top, width: 120*s, height: 30*s)
		humansLabel.topLeft(dx: reflightsLabel.right, dy: reflightsLabel.top, width: 120*s, height: 30*s)
		humansValue.topLeft(dx: humansLabel.right+5*s, dy: reflightsLabel.top, width: 120*s, height: 30*s)
	}
}
